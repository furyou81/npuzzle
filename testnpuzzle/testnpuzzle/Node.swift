//
//  Node.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

class Node: Comparable, Hashable {
    let state: [[Int]]
    let parent: Node?
    let cost: Int
    var heuristic: Int
    let zeroRow: Int
    let zeroCol: Int
    let hash: String
    let flatState: [Int]
    
    var score: Int {
        return cost + heuristic
    }
    
    init(state: [[Int]], parent: Node?, zeroRow: Int, zeroCol: Int, cost: Int, heuristic: Int = 0) {
        self.state = state
        self.parent = parent
        self.cost = cost
        self.heuristic = heuristic
        self.zeroRow = zeroRow
        self.zeroCol = zeroCol
        self.flatState = Array(state.joined())
        
        var h = "";
        for i in self.flatState {
            h += String(i)
        }
        self.hash = h;
    }
    
    var hashValue: Int {
        return (Int) (cost + heuristic)
    }
    
    static func <(lhs: Node, rhs: Node) -> Bool {
        return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
    }
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.hash == rhs.hash
    }
    
    func draw() {
        var nb = 0;
        var current = self
        while current.parent != nil {
            
            var drawing: String = ""
            print("move \(nb): ")
            for row in current.state {
                for column in row {
                    drawing = drawing + String(describing: column) + " "
                }
                drawing = drawing + "\n"
            }

            print(drawing)
            
            current = current.parent!
            nb = nb + 1
        }
    }
    
    
    /*
     OLD IMPLEMENTATION
     */
    
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
    
    
    private func findNilPosition() -> (Int, Int)? {
        for (i, row) in self.state.enumerated() {
            for (j, column) in row.enumerated() {
                if column == 0 {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    private func myswap(from position: (Int, Int), to direction: Direction) -> [[Int]] {
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
    
    func findPossibleState() -> [[[Int]]] {
        var possibleStates: [[[Int]]] = [];
        let nilPosition = findNilPosition()
        let directions = findDirections(from: nilPosition)
        
        if let pos = nilPosition {
            for direction in directions {
                let newState = myswap(from: pos, to: direction)
                possibleStates.append(newState)
            }
        }
        return possibleStates;
    }
}



enum Direction {
    case up, down, right, left
}
