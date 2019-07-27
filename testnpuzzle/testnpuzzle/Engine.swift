//
//  Engine.swift
//  testnpuzzle
//
//  Created by Leo-taro FUJIMOTO on 7/27/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

enum Algorithm {
    case ASTAR
    case GREEDY
}

class Engine {
    let startState: [[Int]]
    let SIZE: Int
    let WEIGHT: Int // weight of the heuristic
    var performHeuristic: Dictionary<Heuristic, ([[Int]]) -> Int>?
    
    let choosenHeuristic: Heuristic
    let choosenAlgorithm: Algorithm
    var goalState: [[Int]]?
    var storedGoalCoordinates: Dictionary<Int, (row: Int, col: Int)>?
    
    var count = 0
    
    init(startState: [[Int]], choosenHeuristic: Heuristic, choosenAlgorithm: Algorithm, WEIGHT: Int = 1) {
        self.startState = startState
        self.SIZE = startState.count - 1
        self.WEIGHT = WEIGHT
        self.choosenHeuristic = choosenHeuristic
        self.choosenAlgorithm = choosenAlgorithm
        self.goalState = findGoal()
        self.storedGoalCoordinates = storeGoalCoordinates()
        self.performHeuristic = getHeuristics(SIZE: self.SIZE, goalState: self.goalState!, storedGoalCoordinates: self.storedGoalCoordinates!)
    }
    
    private func findGoal() -> [[Int]] {
        var goal: [[Int]] = startState
        var numbers: [Int] = goal.flatMap({
            $0
        }).filter({
            $0 != 0
        })
        numbers = numbers.sorted(by: {$0 < $1})
        var numberIndex = 0
        var x = 0
        for y in 0...(SIZE / 2) {
            for xx in (x)...(SIZE - x) {
                goal[y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                numberIndex = numberIndex + 1
            }
            if (y + 1) <= (SIZE - y - 1) {
                for yy in (y + 1)...(SIZE - y - 1) {
                    goal[yy][SIZE - x] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                    numberIndex = numberIndex + 1
                }
            }
            for xx in (x...(SIZE - x)).reversed() {
                goal[SIZE - y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                numberIndex = numberIndex + 1
            }
            if (y + 1) <= (SIZE - y - 1) {
                for yy in ((y + 1 )...(SIZE - y - 1)).reversed() {
                    goal[yy][x] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                    numberIndex = numberIndex + 1
                }
            }
            x = x + 1
        }
        return goal
    }
    
    private func storeGoalCoordinates() -> Dictionary<Int, (row: Int, col: Int)> {
        var storedCoord: Dictionary<Int, (row: Int, col: Int)> = [:]
        
        for i in 0...SIZE {
            for j in 0...SIZE {
                storedCoord[goalState![i][j]] = (row: i, col: j)
            }
        }
        return storedCoord
    }

    static func findCoordinates(_ number: Int, in state: [[Int]], SIZE: Int) -> (row: Int, col: Int)? {
        for i in 0...SIZE {
            for j in 0...SIZE {
                if state[i][j] == number {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    private func childFactory(state: inout [[Int]], parent node: Node, _ x: Int, _ y: Int, _ newX: Int, _ newY: Int) -> Node{
        // swap new position
        state[x][y] = state[newX][newY]
        state[newX][newY] = 0
        
        // create child
        let child = Node(state: state, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: performHeuristic![choosenHeuristic]!(state) * WEIGHT)
        return child
    }
    
    private func getChildren(_ node: Node) -> [Node] {
        var children:[Node] = []
        
        let x = node.zeroRow
        let y = node.zeroCol
        
        var copyState: [[Int]];
        
        // Check if we can go up
        if (x > 0) {
            copyState = node.state;
            let newX = x - 1
            let newY = y
            children.append(childFactory(state: &copyState, parent: node, x, y, newX, newY))
        }
        
        // down
        if (x < node.state.count - 1) {
            copyState = node.state;
            let newX = x + 1
            let newY = y
            children.append(childFactory(state: &copyState, parent: node, x, y, newX, newY))
        }
        
        // left
        if (y > 0) {
            copyState = node.state;
            let newX = x
            let newY = y - 1
            children.append(childFactory(state: &copyState, parent: node, x, y, newX, newY))
        }
        
        // right
        if (y < node.state[0].count - 1) {
            copyState = node.state;
            let newX = x
            let newY = y + 1
            children.append(childFactory(state: &copyState, parent: node, x, y, newX, newY))
        }
        
        return children
    }
    
    func execute() {
        switch choosenAlgorithm {
        case .ASTAR:
            executeAstar()
        case .GREEDY:
            executeGreedy()
        }
    }
    
    private func executeAstar() {
        let (x, y) = Engine.findCoordinates(0, in: startState, SIZE: SIZE)!
        let (goalX, goalY) = storedGoalCoordinates![0]!
        
        let root = Node(state: startState, parent: nil, zeroRow: x, zeroCol: y, cost: 0, heuristic: performHeuristic![choosenHeuristic]!(startState) * WEIGHT)
        let goalNode = Node(state: goalState!, parent: nil, zeroRow: goalX, zeroCol: goalY, cost: 0)
        var openList = PriorityQueue(queue: [root])
        var closedList = Dictionary<String, Node>()
        while (!openList.isEmpty) {
            let currentNode = openList.pop()
            let children = getChildren(currentNode!)
            
            closedList[currentNode!.hash] = currentNode
            
            for child in children {
                // if child is the solution we can stop
                if (child == goalNode) {
                    closedList[child.hash] = child
                    print("Done")
                    child.draw()
                    print("Open list: ", openList.count)
                    print("Close list: ", closedList.count)
                    return
                }
                
                if (closedList[child.hash] == nil) {
                    openList.push(child)
                    count += 1;
                    // if closedList.count % 1000 == 0 { print (closedList.count) }
                }
                
            }
        }
    }
    
    private func executeGreedy() {
        let (x, y) = Engine.findCoordinates(0, in: startState, SIZE: SIZE)!
        let (goalX, goalY) = storedGoalCoordinates![0]!
        
        let root = Node(state: startState, parent: nil, zeroRow: x, zeroCol: y, cost: 0, heuristic: performHeuristic![choosenHeuristic]!(startState) * WEIGHT)
        let goalNode = Node(state: goalState!, parent: nil, zeroRow: goalX, zeroCol: goalY, cost: 0)
        var openList = PriorityQueue(queue: [root])
        var closedList = Dictionary<String, Node>()
        
        var found: Bool = false
        
        var currentNode: Node? = root
        while (!found && currentNode != nil) {
            print("CURRENT", currentNode!.hash, currentNode!.score, currentNode!.cost, currentNode!.heuristic)
            //        let currentNode = openList.pop()
            let children = getChildren(currentNode!)
            
            closedList[currentNode!.hash] = currentNode
            var bestChild: Node? = nil
            
            for child in children {
                print("CHILD", child.hash, child.score, child.cost, child.heuristic)
                // if child is the solution we can stop
                if (child == goalNode) {
                    found = true
                    closedList[child.hash] = child
                    print("Done")
                    child.draw()
                    print("Open list: ", openList.count)
                    print("Close list: ", closedList.count)
                    return
                }
                
                if (closedList[child.hash] == nil) {
                    if (bestChild == nil) {
                        bestChild = child
                    } else {
                        if child.score < bestChild!.score {
                            bestChild = child
                        }
                    }
                    openList.push(child)
                    count += 1;
                }
                
            }
            currentNode = bestChild
        }
    }
}
