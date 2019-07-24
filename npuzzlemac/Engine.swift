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
    var terminalNodes: PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
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
        var goal: [[Int]] = self.rootNode.state
        var numbers: [Int] = goal.flatMap({
            $0
        }).filter({
            $0 != 0
        })
        
       
        numbers = numbers.sorted(by: {$0 < $1})
        let xmax = self.puzzleSize - 1
        let ymax = self.puzzleSize - 1
        
        var numberIndex = 0
        var x = 0
            for y in 0...(ymax / 2) {
                    for xx in (x)...(xmax - x) {
                        goal[y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                        numberIndex = numberIndex + 1
                    }
                if (y + 1) <= (ymax - y - 1) {
                    for yy in (y + 1)...(ymax - y - 1) {
                        goal[yy][xmax - x] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                        numberIndex = numberIndex + 1
                    }
                }
                    for xx in (x...(xmax - x)).reversed() {
                        goal[ymax - y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                        numberIndex = numberIndex + 1
                    }
                if (y + 1) <= (ymax - y - 1) {
                    for yy in ((y + 1 )...(ymax - y - 1)).reversed() {
                        goal[yy][x] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                        numberIndex = numberIndex + 1
                    }
                }
                x = x + 1
            }
        self.goalState = Node(state: goal, np: (0, 0))
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
            
            let children = current!.findPossibleState();
            
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
                
                let old = manhattan(nilPos: child.nilPosition, nb: child.state[(current?.nilPosition.0)!][(current?.nilPosition.1)!], flatState: (current?.flatState)!)
                let new = manhattan(nilPos: current!.nilPosition, nb: child.state[(current?.nilPosition.0)!][(current?.nilPosition.1)!], flatState: (child.flatState))
                child.scoreH = (current?.scoreH)! + (new - old)
                child.scoreG = (current?.scoreG)! + 1;
                
                if (openList.queue.contains(where: { $0 == child && $0.scoreF < child.scoreF })) {
                    continue ;
                }
                
                if (closedList[child.hash] != nil) {
                    if (child.scoreF > (closedList[child.hash]?.scoreF)!) {
                        continue
                    }
                }
                
                openList.enqueue(node: child);
            }
            closedList[(current?.hash)!] = current;
        }
    }
    
//    func getChildren(current: Node) -> [Node] {
//        var children: [Node] = [];
//
//        let states = current.findPossibleState()
//        for child in states {
//            let newNode = Node(state: child, parent: current)
//            children.append(newNode)
//        }
//        return children
//    }
    
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
        for y in 0...(self.puzzleSize - 1) {
            for x in 0...(self.puzzleSize - 1) {
                if node.state[y][x] != 0 && node.state[y][x] != self.goalState?.state[y][x] {
                    misplacedTiles = misplacedTiles + 1
                }
            }
        }
        return misplacedTiles
    }
    
    func manhattanHeuristic(node: Node) -> Int{
        var manhattanDistances = 0
        for y in 0...(self.puzzleSize - 1) {
            for x in 0...(self.puzzleSize - 1) {
                if node.state[y][x] != 0 && node.state[y][x] != self.goalState?.state[y][x] {
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
    
    func manhattan(nilPos: (Int, Int), nb: Int, flatState: [Int]) -> Int{
        if nb != 0 && nb != self.goalState?.state[nilPos.0][nilPos.1] {
            let currentIndex = flatState.index(where: {$0 == nb})
            let goalIndex = self.goalState?.flatState.index(where: {$0 == nb})
            let h = abs(currentIndex! / puzzleSize - goalIndex! / puzzleSize)
            let w = abs(currentIndex! % puzzleSize - goalIndex! % puzzleSize)
            return  h + w
        } else {
            return 0
        }
    }
    
    func isVisited(state: [[Int]]) -> Bool {
        let n = Node(state: state, np: (0, 0))
        return visitedStates[n.hash] != nil
    }
    
}
