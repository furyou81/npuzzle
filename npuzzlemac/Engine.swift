//
//  Engine.swift
//  npuzzlemac
//
//  Created by Leo-taro FUJIMOTO on 7/22/19.
//  Copyright © 2019 Leo-taro FUJIMOTO. All rights reserved.
//

import Foundation

enum Strategy {
    case misplacedTiles, euclidean, manhattan
}

enum Direction {
    case up, down, right, left
}

class Engine {
    var rootNode: Node
    var goalState: Node?
    var visitedStates: [String: Node] = [:]
    var terminalNodes: PrioriryQueue = PrioriryQueue()
    var isFound: Bool = false
    var heuristic: Strategy
    var puzzleSize: Int
    
    init(rootNode: Node, heuristic: Strategy) {
        self.rootNode = rootNode
        self.heuristic = heuristic
        self.puzzleSize = rootNode.state.count
        findGoal()
        self.rootNode = applyHeuristic(node: rootNode, heuristic: heuristic)
        
    }
    
    func findGoal() {
        var goal: [[Int?]] = self.rootNode.state
        let optionalNumbers: [Int?] = goal.flatMap({
           $0
        })
        var numbers: [Int] = optionalNumbers.flatMap({
            $0
        })
       
        numbers = numbers.sorted(by: {$0 < $1})
        let xmax = goal[0].count - 1
        let ymax = goal.count - 1
        
        var numberIndex = 0
        var x = 0
            for y in 0...(ymax / 2) {
                    for xx in (x)...(xmax - x) {
                        goal[y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : nil
                        numberIndex = numberIndex + 1
                    }
                if (y + 1) <= (ymax - y - 1) {
                    for yy in (y + 1)...(ymax - y - 1) {
                        goal[yy][xmax - x] = numberIndex < numbers.count ? numbers[numberIndex] : nil
                        numberIndex = numberIndex + 1
                    }
                }
                    for xx in (x...(xmax - x)).reversed() {
                        goal[ymax - y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : nil
                        numberIndex = numberIndex + 1
                    }
                if (y + 1) <= (ymax - y - 1) {
                    for yy in ((y + 1 )...(ymax - y - 1)).reversed() {
                        goal[yy][x] = numberIndex < numbers.count ? numbers[numberIndex] : nil
                        numberIndex = numberIndex + 1
                    }
                }
                x = x + 1
            }
        self.goalState = Node(state: goal)
        print("GOAL")
        self.goalState?.draw()
    }
    
    
    func execute() {
        var openList = PrioriryQueue()
        var closedList: [String: Node] = [:]
        
        openList.enqueue(node: rootNode)
        
        
        while !openList.isEmpty {
            if closedList.count % 1000 == 0 {
                print("CLOSED: ", closedList.count)
            }
            let current = openList.dequeue()
            
            let children = getChildren(current: current!);
            
            for child in children {
                
                // if successor is the goal, stop search
                if child.hash == goalState?.hash {
                    print("END")
                    
                    var n = child;
                    var nb = 0;
                    while n.parent != nil {
                        n.draw()
                        n = n.parent!
                        nb = nb + 1
                    }
                    print("nb: ", nb, "open: ", openList.count, "closed: ", closedList.count)
                    
                    return
                }
                
                
                let c = applyHeuristic(node: child, heuristic: .manhattan);
                c.scoreG = (current?.scoreG)! + 1;
                
                if (openList.queue.contains(where: { $0 == c && $0.scoreF < c.scoreF })) {
                    continue ;
                }
                
                if (closedList[c.hash] != nil) {
                    if (c.scoreF > (closedList[c.hash]?.scoreF)!) {
                        continue
                    }
                }
                
                openList.enqueue(node: c);
            }
            closedList[(current?.hash)!] = current;
            
        }
        
    }
    
    func getChildren(current: Node) -> [Node] {
        var children: [Node] = [];
        
        let states = current.findPossibleState()
        for child in states {
            let newNode = Node(state: child, parent: current)
            children.append(newNode)
        }
        return children
    }
    
    
    
    func resolve() {
//        findChildren(node: rootNode)
            terminalNodes.enqueue(node: rootNode)
        
        while !isFound && terminalNodes.count > 0 {
//            print("QUEUE: ", terminalNodes.queueInt)
            if visitedStates.count % 1000 == 0 {
                print("VISITED: ", visitedStates.count)
            }
            if let nextToExplore: Node = terminalNodes.dequeue() {
//                print("_______________________________________")
//                print("NEXT TO EXPLORE", "F", nextToExplore.scoreF, "G", nextToExplore.scoreG, "H", nextToExplore.scoreH)
//                nextToExplore.draw()
//                print("_______________________________________")
                if isVisited(state: nextToExplore.state) {
//                    print("VVVVVVVVVVV_________________________________________________________")
                    return
                }
                visitedStates[nextToExplore.hash] = nextToExplore
//                print("QUEUE AFTER REMOVE: ", terminalNodes.queueInt)
//                print("Choosen: ", nextToExplore.hash, "score: ", nextToExplore.scoreF);
//                print("count: ", terminalNodes.count)
//                print("NEXT", nextToExplore.draw(), nextToExplore.scoreF, terminalNodes.count, isFound)
                findChildren(node: nextToExplore)
            }
        }
        
        
        
    }
    
    func applyHeuristic(node: Node, heuristic: Strategy) -> Node {
        switch heuristic {
        case .misplacedTiles:
            node.scoreH = misplacedTilesHeuristic(node: node)
        case .euclidean:
            print("euclidean")
        case .manhattan:
            node.scoreH = manhattanHeuristic(node: node)
        }
        return node;
    }
    
    func misplacedTilesHeuristic(node: Node) -> Int{
        var misplacedTiles = 0
        for y in 0...(node.state.count - 1) {
            for x in 0...(node.state[0].count - 1) {
                if node.state[y][x] != nil && node.state[y][x] != self.goalState?.state[y][x] {
                    misplacedTiles = misplacedTiles + 1
                }
            }
        }
        return misplacedTiles
    }
    
    func manhattanHeuristic(node: Node) -> Int{
        var manhattanDistances = 0
        for y in 0...(node.state.count - 1) {
            for x in 0...(node.state[0].count - 1) {
                if node.state[y][x] != nil && node.state[y][x] != self.goalState?.state[y][x] {
                let currentIndex = node.flatState.index(where: {$0 == node.state[y][x]})
                let goalIndex = self.goalState?.flatState.index(where: {$0 == node.state[y][x]})
                let h = abs(currentIndex! / puzzleSize - goalIndex! / puzzleSize)
                let w = abs(currentIndex! % puzzleSize - goalIndex! % puzzleSize)
                manhattanDistances = manhattanDistances + h + w
                }
            }
        }
        return manhattanDistances
    }
    
    func findChildren(node: Node) {
        if node == goalState! {
            self.isFound = true
//            print("FOUND", node.scoreF, node.scoreH)
            var n = node
            var nb = 0;
            while n.parent != nil {
//                n.draw()
                n = n.parent!
                nb = nb + 1
            }
            
//            n.draw()
//            print("STEP: ", nb)
//            print("VISITED: ", visitedStates.count)
            return
        }
//        print("PARENT", node.scoreF, node.scoreG, node.scoreH)
//        node.draw()
//        visitedStates[node.hash] = node
        let children = node.findPossibleState()
        for child in children {
            if !isVisited(state: child) {
                var newNode = Node(state: child, parent: node)
                
//                newNode.draw()
                newNode = applyHeuristic(node: newNode, heuristic: self.heuristic)
//                print("CHILD", newNode.scoreF, newNode.scoreG, newNode.scoreH)
                if needToBeAddedToTerminalNodes(newNode) {
                    terminalNodes.enqueue(node: newNode)
                }
            }
        }
//        print("NODE", terminalNodes.count)
////        terminalNodes = terminalNodes.filter({
////            $0 != node
////        })
//        print("AFTER", terminalNodes.count)
//        print("Queue Int: ", self.terminalNodes.queueInt);
//        print("___________________________________________")
    }
    
    func needToBeAddedToTerminalNodes(_ newNode: Node) -> Bool {
        let isInTerminalNodes = terminalNodes.queue.contains(where: {
            $0 == newNode
        })
        return !isInTerminalNodes
    }
    
    func isVisited(state: [[Int?]]) -> Bool {
        let n = Node(state: state)
        return visitedStates[n.hash] != nil
    }
    
}
