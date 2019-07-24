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
        self.rootNode.scoreH =  manhattanHeuristic(node: &self.rootNode);
        
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
        
        openList.enqueue(node: &rootNode)
        
        
        while !openList.isEmpty {
            var current = openList.dequeue()
            var children = getChildren(current: &current!);
            
            for (childIndex, _) in children.enumerated() {
                
                // if successor is the goal, stop search
                if children[childIndex].hash == goalState?.hash {
                    print("END")
                    return
                }

                children[childIndex].scoreH =  manhattanHeuristic(node: &children[childIndex]);
                children[childIndex].scoreG = (current?.scoreG)! + 1;
                
                if (openList.queue.contains(where: { $0 == children[childIndex] && $0.scoreF < children[childIndex].scoreF })) {
                    continue ;
                }
                
                if (closedList[children[childIndex].hash] != nil) {
                    if (children[childIndex].scoreF > (closedList[children[childIndex].hash]?.scoreF)!) {
                        continue
                    }
                }
                
                openList.enqueue(node: &children[childIndex]);
            }
            closedList[(current?.hash)!] = current;
        }
    }
    
    func getChildren(current: inout Node) -> [Node] {
        var children: [Node] = [];
        
        let states = current.findPossibleState()
        
        for (childIndex, _) in states.enumerated() {
            children.append(Node(state: states[childIndex], parent: current))
        }
        return children
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
    
    func manhattanHeuristic(node: inout Node) -> Int{
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
}
