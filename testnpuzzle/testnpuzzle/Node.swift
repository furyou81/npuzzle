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
        var current: Node? = self
        while current != nil {
            
            var drawing: String = ""
            print("move \(nb): scoreF \(current!.score) G \(current!.cost) H \(current!.heuristic)")
            for row in current!.state {
                for column in row {
                    drawing = drawing + String(describing: column) + " "
                }
                drawing = drawing + "\n"
            }
            
            print(drawing)
            
            current = current!.parent
            nb = nb + 1
        }
        
    }
}
