//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

let SIZE = 4;

var startState = [
    [3, 13, 4, 5],
    [14, 8, 0, 6],
    [2, 15, 7, 9],
    [12, 10, 11, 1]
]
//var startState = [
//    [0, 2, 3],
//    [1, 4, 5],
//    [8, 7, 6]
//]
//
//var goalState = [
//    [1, 2, 3],
//    [8, 0, 4],
//    [7, 6, 5]
//]

var goalState = [
    [1, 2, 3, 4],
    [12, 13, 14, 5],
    [11, 0, 15, 6],
    [10, 9, 8, 7]
]

//var goal = Node(state: startState, parent: nil, zeroRow: 2, zeroCol: 1, cost: 0, heuristic: 0)

func findCoordinates(_ number: Int) -> (row: Int, col: Int)? {
    for i in 0..<SIZE {
        for j in 0..<SIZE {
            if goalState[i][j] == number {
                return (i, j)
            }
        }
    }
    return nil
}

func manhattan(_ state: [[Int]]) -> Int {
    var distance = 0
    for i in 0...state.count - 1 {
        for j in 0...state[i].count - 1 {
            if (state[i][j] == 0) {
                continue
            }
            let (row, col) = findCoordinates(state[i][j])!
            let absRow = abs(i - row)
            let absCol = abs(j - col)
            distance += (absRow + absCol)
            // print("For : ", state[i][j], "coord in goal : ", row, col, " absR: ", absRow, "absC : ", absCol, " distance: ", distance)
        }
    }
    return distance;
}

func getChildren(_ node: Node) -> [Node] {
    var children:[Node] = []
    
    let x = node.zeroRow
    let y = node.zeroCol
    
    // Check if we can go up
    if (x > 0) {
        var copyState = node.state;
        let newX = x - 1
        let newY = y

        // swap new position
        copyState[x][y] = copyState[newX][newY]
        copyState[newX][newY] = 0
        
        // create child
        let child = Node(state: copyState, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: manhattan(copyState))
        children.append(child)
    }
    
    // down
    if (x < node.state.count - 1) {
        var copyState = node.state;
        let newX = x + 1
        let newY = y
        
        // swap new position
        copyState[x][y] = copyState[newX][newY]
        copyState[newX][newY] = 0
        
        // create child
        let child = Node(state: copyState, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: manhattan(copyState))
        children.append(child)
    }
    
    // left
    if (y > 0) {
        var copyState = node.state;
        let newX = x
        let newY = y - 1
        
        // swap new position
        copyState[x][y] = copyState[newX][newY]
        copyState[newX][newY] = 0
        
        // create child
        let child = Node(state: copyState, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: manhattan(copyState))
        children.append(child)
    }
    
    // right
    if (y < node.state[0].count - 1) {
        var copyState = node.state;
        let newX = x
        let newY = y + 1
        
        // swap new position
        copyState[x][y] = copyState[newX][newY]
        copyState[newX][newY] = 0
        
        // create child
        let child = Node(state: copyState, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: manhattan(copyState))
        children.append(child)
    }
    
    return children
}

var goalNode = Node(state: goalState, parent: nil, zeroRow: 2, zeroCol: 1, cost: 0, heuristic: 0)
var root = Node(state: startState, parent: nil, zeroRow: 1, zeroCol: 2, cost: 0, heuristic: manhattan(startState))

var count = 0;

func execute() {
    var openList = PriorityQueue(ascending: true, startingValues: [root])
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

let startTime = CFAbsoluteTimeGetCurrent()
execute()
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Time elapsed for : \(timeElapsed) s.")
