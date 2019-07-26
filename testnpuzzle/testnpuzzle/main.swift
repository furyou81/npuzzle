//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation



/*var startState = [
    [3, 13, 4, 5],
    [14, 8, 0, 6],
    [2, 15, 7, 9],
    [12, 10, 11, 1]
]*/
var startState = [
    [0, 2, 3],
    [1, 4, 5],
    [8, 7, 6]
]

var goalState = [
    [1, 2, 3],
    [8, 0, 4],
    [7, 6, 5]
]

/*var goalState = [
    [1, 2, 3, 4],
    [12, 13, 14, 5],
    [11, 0, 15, 6],
    [10, 9, 8, 7]
]
*/

let SIZE = startState.count - 1;
let WEIGHT = 1

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
            // print("New coord in goal:: row-> ", row, "  col-> ", col, "value: ", state[i][j], "absRow  \(absRow)  absCol \(absCol)   moveToGoal: \(absRow + absCol)  total: \(distance)")
        }
    }
    return distance;
}

func euclidean(_ state: [[Int]]) -> Int {
    // p = (p1, p2) and q = (q1, q2)
    var distance = 0.0
    for i in 0...SIZE {
        for j in 0...SIZE {
            if (state[i][j] == 0) {
                continue
            }
            let (row, col) = findCoordinates(state[i][j], in: goalState)!
            
            distance += sqrt(pow((Double(row - i)), 2) + pow((Double(col - j)), 2))
            print("New coord in goal:: row-> ", row, "  col-> ", col, "value: ", state[i][j], "absRow  \(pow((Double(row - i)), 2))  absCol \(pow((Double(col - j)), 2))  total: \(distance)")
        }
    }
    print("SQRT: ", distance)
    return Int(sqrt(distance));
}

func childFactory(state: inout [[Int]], parent node: Node, _ x: Int, _ y: Int, _ newX: Int, _ newY: Int) -> Node{
    // swap new position
    state[x][y] = state[newX][newY]
    state[newX][newY] = 0
    
    // create child
    let child = Node(state: state, parent: node, zeroRow: newX, zeroCol: newY, cost: node.cost + 1, heuristic: euclidean(state) * WEIGHT)
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

var root = Node(state: startState, parent: nil, zeroRow: x, zeroCol: y, cost: 0, heuristic: euclidean(startState) * WEIGHT)
var goalNode = Node(state: goalState, parent: nil, zeroRow: goalX, zeroCol: goalY, cost: 0, heuristic: 0)

//print(root.flatState)
//print(goalNode.flatState)

var count = 0;

func execute() {
    var openList = PriorityQueue(queue: [root])
    var closedList = Dictionary<String, Node>()
    
    while (!openList.isEmpty) {
        let currentNode = openList.pop()
        let children = getChildren(currentNode!)
        
        // let children = oldGetChildren(current: currentNode!)
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



// ###############################    OLD
func oldGetChildren(current: Node) -> [Node] {
    var children: [Node] = [];
    
    let states = current.findPossibleState()
    
    for (childIndex, _) in states.enumerated() {
        children.append(Node(state: states[childIndex], parent: current, zeroRow: -1, zeroCol: -1, cost: current.cost + 1, heuristic: manhattan(states[childIndex])))
    }
    return children
}


// ##########################  OLD
func oldManhattanHeuristic(node: Node) -> Int{
    var manhattanDistances = 0
    for y in 0...SIZE {
        for x in 0...SIZE {
            if node.state[y][x] != 0 && node.state[y][x] != goalNode.state[y][x] {
                let currentIndex = node.flatState.index(where: {$0 == node.state[y][x]})
                let goalIndex = goalNode.flatState.index(where: {$0 == node.state[y][x]})
                
                let h = abs(currentIndex! / SIZE - goalIndex! / SIZE)
                let w = abs(currentIndex! % SIZE - goalIndex! % SIZE)
                
                
                manhattanDistances = manhattanDistances + h + w
                print("Old coord in goal:: currentIndex-> ", currentIndex!, "  goalIndex-> ", goalIndex!, "value: ", node.state[y][x], "absRow  \(h)  absCol \(w)   moveToGoal: \(h + w)  total: \(manhattanDistances)")
            }
        }
    }
    return manhattanDistances
}


let startTime = CFAbsoluteTimeGetCurrent()
print("started")

execute()
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Time elapsed for : \(timeElapsed) s.")
