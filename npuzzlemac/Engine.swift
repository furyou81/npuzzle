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
//        self.rootNode = applyHeuristic(node: rootNode, heuristic: heuristic)
        
    }
    
    func findGoal() {
        var goal: [[Int]] = self.rootNode.state
//        let optionalNumbers: [Int?] = goal.flatMap({
//           $0
//        })
        var numbers: [Int] = goal.flatMap({
            $0
        })
        
       
        numbers = numbers.sorted(by: {$0 < $1})
        let xmax = goal[0].count - 1
        let ymax = goal.count - 1
        
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
//        self.goalState = Node(state: goal)
//        print("GOAL")
//        self.goalState?.draw()
                self.goalState = Node(state: [
                    [1, 2, 3, 4],
                    [12, 13, 14, 5],
                    [11, 0, 15, 6],
                    [10, 9, 8, 7]
                    ], nilPosition: (2, 1), scoreH: 0)
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
            
            let children = current!.findPossibleState()
            
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
                
                
//                let c = applyHeuristic(node: child, heuristic: .manhattan);
                child.scoreG = (current?.scoreG)! + 1;
//                child.draw()
//                print("SCORE ",child.scoreF, child.scoreG, child.scoreH )
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

//    func applyHeuristic(node: Node, heuristic: Strategy) -> Node {
//        switch heuristic {
//        case .misplacedTiles:
//            node.scoreH = misplacedTilesHeuristic(node: node)
//        case .euclidean:
//            print("euclidean")
//        case .manhattan:
//            node.scoreH = manhattanHeuristic(node: node)
//        }
//        return node;
//    }
//
//    func misplacedTilesHeuristic(node: Node) -> Int{
//        var misplacedTiles = 0
//        for y in 0...(node.state.count - 1) {
//            for x in 0...(node.state[0].count - 1) {
//                if node.state[y][x] != 0 && node.state[y][x] != self.goalState?.state[y][x] {
//                    misplacedTiles = misplacedTiles + 1
//                }
//            }
//        }
//        return misplacedTiles
//    }
//
//    func manhattanHeuristic(node: Node) -> Int{
//        var manhattanDistances = 0
//        for y in 0...(node.state.count - 1) {
//            for x in 0...(node.state[0].count - 1) {
//                if node.state[y][x] != 0 && node.state[y][x] != self.goalState?.state[y][x] {
//                let currentIndex = node.flatState.index(where: {$0 == node.state[y][x]})
//                let goalIndex = self.goalState?.flatState.index(where: {$0 == node.state[y][x]})
//                let h = abs(currentIndex! / puzzleSize - goalIndex! / puzzleSize)
//                let w = abs(currentIndex! % puzzleSize - goalIndex! % puzzleSize)
//                manhattanDistances = manhattanDistances + h + w
//                }
//            }
//        }
//        return manhattanDistances
//    }
    
    func needToBeAddedToTerminalNodes(_ newNode: Node) -> Bool {
        let isInTerminalNodes = terminalNodes.queue.contains(where: {
            $0 == newNode
        })
        return !isInTerminalNodes
    }
    
}
