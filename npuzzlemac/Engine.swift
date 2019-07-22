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
    var visitedStates: [Node] = []
    var terminalNodes: [Node] = []
    var isFound: Bool = false
    var heuristic: Strategy
    
    init(rootNode: Node, heuristic: Strategy) {
        self.rootNode = rootNode
        self.heuristic = heuristic
        findGoal()
        applyHeuristic(node: rootNode, heuristic: heuristic)
        
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
    }
    
    func resolve() {
        findChildren(node: rootNode)
        
        while !isFound && terminalNodes.count > 0 {
            var nextToExplore: Node = terminalNodes.min(by: {
                $0.scoreF < $1.scoreF
            })!
            print("NEXT", nextToExplore.draw(), nextToExplore.scoreF, terminalNodes.count, isFound)
            findChildren(node: nextToExplore)
        }
        
        
        
    }
    
    func applyHeuristic(node: Node, heuristic: Strategy) {
        switch heuristic {
        case .misplacedTiles:
            node.scoreH = misplacedTilesHeuristic(node: node)
        case .euclidean:
            print("euclidean")
        case .manhattan:
            print("man")
        }
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
    
    func findChildren(node: Node) {
        if node == goalState! {
            self.isFound = true
            print("FOUND", node.scoreF, node.scoreH)
            var n = node
            while n.parent != nil {
                n.draw()
                n = n.parent!
            }
            n.draw()
            return
        }
        print("PARENT", node.scoreF, node.scoreG, node.scoreH)
        node.draw()
        visitedStates.append(node)
        let children = node.findPossibleState()
        for child in children {
            if !isVisited(state: child) {
                let newNode = Node(state: child, parent: node)
                
                newNode.draw()
                applyHeuristic(node: newNode, heuristic: self.heuristic)
                print("CHILD", newNode.scoreF, newNode.scoreG, newNode.scoreH)
                if needToBeAddedToTerminalNodes(newNode) {
                    terminalNodes.append(newNode)
                    node.addChild(newNode)
                }
            }
        }
        terminalNodes = terminalNodes.filter({
            $0 != node
        })
        print("___________________________________________")
    }
    
    func needToBeAddedToTerminalNodes(_ newNode: Node) -> Bool {
        let isInTerminalNodes = terminalNodes.contains(where: {
            $0 == newNode
        })
        let isBetter = terminalNodes.contains(where: {
            $0.scoreG > newNode.scoreG
        })
        
        terminalNodes = terminalNodes.filter({
            $0 != newNode || ($0 == newNode && $0.scoreG < newNode.scoreG)
        })
        return (isInTerminalNodes && isBetter) || !isInTerminalNodes
    }
    
    func isVisited(state: [[Int?]]) -> Bool {
        let n = Node(state: state)
        return visitedStates.contains(where: {
            $0 == n
        })
    }
    
}
