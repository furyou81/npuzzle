//
//  Node.swift
//  npuzzlemac
//
//  Created by Leo-taro FUJIMOTO on 7/22/19.
//  Copyright © 2019 Leo-taro FUJIMOTO. All rights reserved.
//

import Foundation

class Node: Comparable {
    static func <(lhs: Node, rhs: Node) -> Bool {
        return lhs.scoreF <  rhs.scoreF
    }
    
    var parent: Node?
    var scoreG: Int = 0
    var scoreH: Int = 0
    var children: [Node] = []
    var state: [[Int]] = [[]]
    var flatState: [Int] = []
    var hash: String = ""
    var nilPosition: (Int, Int)
    
    var scoreF: Int {
        return scoreG + scoreH
    }
    
    init(state: [[Int]], np: (Int, Int), parent: Node? = nil) {
        self.parent = parent
        self.scoreG = parent == nil ? 0 : parent!.scoreG + 1
        self.state = state
        for row in state {
            for column in row {
                hash = hash + String(column)
            }
        }
        self.flatState = state.flatMap({
            $0
        })
        if (parent == nil) {
            self.nilPosition = Node.findNilPosition(s: state)!
        } else {
            nilPosition = np
        }
    }
    
    func addChild(_ child: Node) {
        self.children.append(child)
    }
    
    func findPossibleState() -> [Node] {
        var possibleStates: [Node] = [];
//        let nilPosition = findNilPosition()
        let directions = findDirections(from: nilPosition)
        
//        if let pos = nilPosition {
            for direction in directions {
//                let newState = Node(state: swap(from: self.nilPosition, to: direction), parent: self)
                var np: (Int, Int)
                switch direction {
                case Direction.down:
                    np = (self.nilPosition.0 + 1, self.nilPosition.1)
                case Direction.up:
                    np = (self.nilPosition.0 - 1, self.nilPosition.1)
                case Direction.left:
                    np = (self.nilPosition.0, self.nilPosition.1 - 1)
                case Direction.right:
                    np = (self.nilPosition.0, self.nilPosition.1 + 1)
                }
                let newState = Node(state: swap(from: self.nilPosition, to: direction), np: np, parent: self)
                possibleStates.append(newState)
            }
//        }
        return possibleStates;
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
    
    static func findNilPosition(s: [[Int]]) -> (Int, Int)? {
        for (i, row) in s.enumerated() {
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
                drawing = drawing + String(column) + " "
            }
            drawing = drawing + "\n"
        }
        print(drawing)
    }
    
}
