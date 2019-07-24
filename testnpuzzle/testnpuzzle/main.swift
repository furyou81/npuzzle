//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation



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

let SIZE = startState.count - 1;

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

func manhattan(_ state: [[Int]]) -> Int {
    var distance = 0
    for i in 0...SIZE {
        for j in 0...SIZE {
            if (state[i][j] == 0) {
                continue
            }
            let (row, col) = findCoordinates(state[i][j], in: goalState)!
            let absRow = abs(i - row)
            let absCol = abs(j - col)
            distance += (absRow + absCol)
            // print("For : ", state[i][j], "coord in goal : ", row, col, " absR: ", absRow, "absC : ", absCol, " distance: ", distance)
        }
    }
    return distance;
}

func childFactory(state: inout [[Int]], parent node: Node, _ x: Int, _ y: Int, _ newX: Int, _ newY: Int) -> Node{
    // swap new position
    state[x][y] = state[newX][newY]
    state[newX][newY] = 0
    
    // create child
    let child = Node(state: state, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: manhattan(state))
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
let (goalX, goalY) = findCoordinates(0, in: goalState)!

var root = Node(state: startState, parent: nil, zeroRow: x, zeroCol: y, cost: 0, heuristic: manhattan(startState))
var goalNode = Node(state: goalState, parent: nil, zeroRow: goalX, zeroCol: goalY, cost: 0, heuristic: 0)


var count = 0;

func execute() {
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

let startTime = CFAbsoluteTimeGetCurrent()
execute()
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Time elapsed for : \(timeElapsed) s.")
