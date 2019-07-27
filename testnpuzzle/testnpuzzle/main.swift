//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

enum Algorithm {
    case ASTAR
    case GREEDY
}

 var startState = [
    [3, 13, 4, 5],
    [14, 8, 0, 6],
    [2, 15, 7, 9],
    [12, 10, 11, 1]
]

// var goalState = [
// [1, 2, 3, 4],
// [12, 13, 14, 5],
// [11, 0, 15, 6],
// [10, 9, 8, 7]
// ]

//var startState = [
//    [0, 2, 3],
//    [1, 4, 5],
//    [8, 7, 6]
//]
/*
var goalState = [
    [1, 2, 3],
    [8, 0, 4],
    [7, 6, 5]
]*/

let SIZE = startState.count - 1;
let WEIGHT = 1
let performHeuristic = getHeuristics()

let choosenHeuristic: Heuristic = .MANHATTAN

let choosenAlgorithm: Algorithm = .GREEDY

func findGoal() -> [[Int]] {
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

let goalState = findGoal();

func storeGoalCoordinates() -> Dictionary<Int, (row: Int, col: Int)> {
    var storedCoord: Dictionary<Int, (row: Int, col: Int)> = [:]
    
    for i in 0...SIZE {
        for j in 0...SIZE {
            storedCoord[goalState[i][j]] = (row: i, col: j)
        }
    }
    return storedCoord
}

let storedGoalCoordinates = storeGoalCoordinates();

func findCoordinates(_ number: Int, in state: [[Int]]) -> (row: Int, col: Int)? {
    for i in 0...SIZE {
        for j in 0...SIZE {
            if state[i][j] == number {
                return (i, j)
            }
        }
    }
    return nil
}

func childFactory(state: inout [[Int]], parent node: Node, _ x: Int, _ y: Int, _ newX: Int, _ newY: Int) -> Node{
    // swap new position
    state[x][y] = state[newX][newY]
    state[newX][newY] = 0
    
    // create child
    let child = Node(state: state, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: performHeuristic[choosenHeuristic]!(state) * WEIGHT)
    return child
}

func getChildren(_ node: Node) -> [Node] {
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


let (x, y) = findCoordinates(0, in: startState)!
let (goalX, goalY) = storedGoalCoordinates[0]!

var root = Node(state: startState, parent: nil, zeroRow: x, zeroCol: y, cost: 0, heuristic: performHeuristic[choosenHeuristic]!(startState) * WEIGHT)
var goalNode = Node(state: goalState, parent: nil, zeroRow: goalX, zeroCol: goalY, cost: 0)

var count = 0;

func executeAstar() {
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

func executeGreedy() {
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

let startTime = CFAbsoluteTimeGetCurrent()
print("started")

//execute()
switch choosenAlgorithm {
    case .ASTAR:
        executeAstar()
    case .GREEDY:
        executeGreedy()
}
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Time elapsed for : \(timeElapsed) s.")
