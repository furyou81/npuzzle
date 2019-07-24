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
    let heuristic: Int
    let zeroRow: Int
    let zeroCol: Int
    let hash: String
    
    init(state: [[Int]], parent: Node?, zeroRow: Int, zeroCol: Int, cost: Int, heuristic: Int) {
        self.state = state
        self.parent = parent
        self.cost = cost
        self.heuristic = heuristic
        self.zeroRow = zeroRow
        self.zeroCol = zeroCol
        
        var h = "";
        for i in Array(state.joined()) {
            h += String(i)
        }
        self.hash = h;
    }
    
    var hashValue: Int { return (Int) (cost + heuristic) }
    
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
}
