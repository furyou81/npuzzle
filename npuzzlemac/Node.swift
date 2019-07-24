//
//  Node.swift
//  npuzzlemac
//
//  Created by Leo-taro FUJIMOTO on 7/22/19.
//  Copyright © 2019 Leo-taro FUJIMOTO. All rights reserved.
//

import Foundation

class Node {
    var parent: Node?
    var scoreG: Int = 0
    var scoreH: Int = 0
    var children: [Node] = []
    var state: [[Int]] = [[]]
    var flatState: [Int] = []
    var hash: String = ""
    var nilPosition: (Int, Int)
    var goalFlat: [Int] = [1, 2, 3, 4, 12, 13, 14, 5, 11, 0, 15, 6, 10, 9, 8, 7]
    
    
    var scoreF: Int {
        return scoreG + scoreH
    }

    init(state: [[Int]], nilPosition: (Int, Int), scoreH: Int, parent: Node? = nil) {
        self.parent = parent
        self.scoreG = parent == nil ? 0 : parent!.scoreG + 1
        self.state = state
        self.nilPosition = nilPosition
        self.scoreH = scoreH
        for row in state {
            for column in row {
                hash = hash + String(column)
            }
        }
        self.flatState = state.flatMap({
            $0
        })
    }
    
    func addChild(_ child: Node) {
        self.children.append(child)
    }
    
    func findChildNilPosition(direction: Direction) -> (Int, Int) {
        switch direction {
        case .down:
            return (nilPosition.0 + 1, nilPosition.1)
        case .up:
            return (nilPosition.0 - 1, nilPosition.1)
        case .left:
            return (nilPosition.0, nilPosition.1 - 1)
        case .right:
            return (nilPosition.0, nilPosition.1 + 1)
        }
    }
    
    func findPossibleState() -> [Node] {
        var possibleStates: [Node] = [];
        let directions = findDirections(from: nilPosition)
        for direction in directions {
//            print("__________________")
//            self.draw()
            let newState = swap(from: nilPosition, to: direction)
            let np = findChildNilPosition(direction: direction)
//            print("SCOREH", scoreH, heuri(direction: direction, parrentNilPosition: nilPosition, childNilPosition: np, nb: newState[nilPosition.0][nilPosition.1]))
            let h = scoreH + heuri(direction: direction, parrentNilPosition: nilPosition, childNilPosition: np, nb: newState[nilPosition.0][nilPosition.1])
            let newN = Node(state: newState, nilPosition: np, scoreH: h, parent: self)
//            newN.draw()
//            print("__________________")
            possibleStates.append(newN)
        }
        return possibleStates;
    }
    
    func heuri(direction: Direction, parrentNilPosition: (Int, Int), childNilPosition: (Int, Int), nb: Int) -> Int {
        let old: Int = manone(currentIndex: childNilPosition, nb: nb)
        let new: Int = manone(currentIndex: parrentNilPosition, nb: nb)
//        print("HEURI", new, old)
        
        
        return new - old
    }
    
    private func swap(from position: (Int, Int), to direction: Direction) -> [[Int]] {
        var newState: [[Int]] = self.state
        switch direction {
        case .down:
            newState[position.0][position.1] = newState[position.0 + 1][position.1]
            newState[position.0 + 1][position.1] = 0
        case .left:
            newState[position.0][position.1] = newState[position.0][position.1 - 1]
            newState[position.0][position.1 - 1] = 0
        case .right:
            newState[position.0][position.1] = newState[position.0][position.1 + 1]
            newState[position.0][position.1 + 1] = 0
        case .up:
            newState[position.0][position.1] = newState[position.0 - 1][position.1]
            newState[position.0 - 1][position.1] = 0
        }
        return newState;
    }
    
    static func findNilPosition(state: [[Int]]) -> (Int, Int)? {
        for (i, row) in state.enumerated() {
            for (j, column) in row.enumerated() {
                if column == 0 {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    private func findDirections(from nilPosition: (Int, Int)?) -> [Direction] {
        var directions: [Direction] = []
        
        if let pos = nilPosition {
            if pos.0 > 0 {
                directions.append(.up)
            }
            if pos.0 < self.state.count - 1 {
                directions.append(.down)
            }
            if pos.1 > 0 {
                directions.append(.left)
            }
            if pos.1 < self.state[0].count - 1 {
                directions.append(.right)
            }
        }
        return directions
    }

    static func ==(onLeft: Node, onRight: Node) -> Bool {
        return onLeft.hash == onRight.hash
    }
    
    static func !=(onLeft: Node, onRight: Node) -> Bool {
        return onLeft.hash != onRight.hash
    }
    
    func draw() {
        var drawing: String = ""
        for row in state {
            for column in row {
                drawing = drawing + String(column)
            }
            drawing = drawing + "\n"
        }
        print(drawing)
    }
    
    static func manhattanHeuristic(state: [[Int]]) -> Int{
        let goalState = Node(state: [
            [1, 2, 3, 4],
            [12, 13, 14, 5],
            [11, 0, 15, 6],
            [10, 9, 8, 7]
            ], nilPosition: (2, 1), scoreH: 0)
        let puzzleSize = goalState.state.count
        let flatState = state.flatMap({
            $0
        })
        var manhattanDistances = 0
        for y in 0...(state.count - 1) {
            for x in 0...(state[0].count - 1) {
                if state[y][x] != 0 && state[y][x] != goalState.state[y][x] {
                    let currentIndex = flatState.index(where: {$0 == state[y][x]})
                    let goalIndex = goalState.flatState.index(where: {$0 == state[y][x]})
                    let h = abs(currentIndex! / puzzleSize - goalIndex! / puzzleSize)
                    let w = abs(currentIndex! % puzzleSize - goalIndex! % puzzleSize)
                    manhattanDistances = manhattanDistances + h + w
                }
            }
        }
        return manhattanDistances
    }
    
    func manone(currentIndex: (Int, Int), nb: Int) -> Int {
        let puzzleSize = 4
        let index = (currentIndex.0 * puzzleSize + currentIndex.1)
        let goalIndex = goalFlat.index(where: {$0 == nb})
        let h = abs(index / puzzleSize - goalIndex! / puzzleSize)
        let w = abs(index % puzzleSize - goalIndex! % puzzleSize)
//        print("H", h, "W", w, "INDEX", index)
        return h + w
    }
    
}
