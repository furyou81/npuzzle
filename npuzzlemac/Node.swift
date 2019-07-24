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
    var state: [[Int?]] = [[]]
    var flatState: [Int?] = []
    var hash: String = ""
    
    var scoreF: Int {
        return scoreG + scoreH
    }
    
    init(state: [[Int?]], parent: Node? = nil) {
        self.parent = parent
        self.scoreG = parent == nil ? 0 : parent!.scoreG + 1
        self.state = state
        
       /* for (rowIndex, _) in self.state.enumerated() {
            for (colIndex, _) in self.state[rowIndex].enumerated() {
                if (self.state[rowIndex][colIndex] != nil) {
                    hash = hash + String(describing: self.state[rowIndex][colIndex])
                } else {
                    hash = hash + "_"
                }
                self.flatState.append(self.state[rowIndex][colIndex])
            }
        }*/
        
        for row in state {
            for column in row {
                if let char = column {
                    hash = hash + String(describing: char)
                    self.flatState.append(char)
                } else {
                    hash = hash + "_"
                    self.flatState.append(nil)
                }
            }
        }
    }
    
    func findPossibleState() -> [[[Int?]]] {
        var possibleStates: [[[Int?]]] = [];
        let nilPosition = findNilPosition()
        let directions = findDirections(from: nilPosition)
        
        if let pos = nilPosition {
            for direction in directions {
                let newState = swap(from: pos, to: direction)
                possibleStates.append(newState)
            }
        }
        return possibleStates;
    }
    
    private func swap(from position: (Int, Int), to direction: Direction) -> [[Int?]] {
        var newState: [[Int?]] = self.state
        switch direction {
        case .down:
            newState[position.0][position.1] = newState[position.0 + 1][position.1]
            newState[position.0 + 1][position.1] = nil
        case .left:
            newState[position.0][position.1] = newState[position.0][position.1 - 1]
            newState[position.0][position.1 - 1] = nil
        case .right:
            newState[position.0][position.1] = newState[position.0][position.1 + 1]
            newState[position.0][position.1 + 1] = nil
        case .up:
            newState[position.0][position.1] = newState[position.0 - 1][position.1]
            newState[position.0 - 1][position.1] = nil
        }
        return newState;
    }
    
    private func findNilPosition() -> (Int, Int)? {
        for (i, row) in self.state.enumerated() {
            for (j, column) in row.enumerated() {
                if column == nil {
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
                if let char = column {
                    drawing = drawing + String(describing: char) + " "
                } else {
                    drawing = drawing + "_" + " "
                }
            }
            drawing = drawing + "\n"
        }
        print(drawing)
    }
    
}
