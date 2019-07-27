//
//  Heuristic.swift
//  testnpuzzle
//
//  Created by eric on 27/07/2019.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

enum Heuristic {
    case MANHATTAN
    case MISSPLACED
    case EUCLIDEAN
}

func manhattan(_ state: [[Int]]) -> Int {
    var heuristic = 0
    for i in 0...SIZE {
        for j in 0...SIZE {
            if (state[i][j] == 0) {
                continue
            }
            
            let (row, col) = storedGoalCoordinates[state[i][j]]!
            
            let absRow = abs(i - row)
            let absCol = abs(j - col)
            
            heuristic += (absRow + absCol)
        }
    }
    return heuristic;
}

func missplaced(_ state: [[Int]]) -> Int{
    var heuristic = 0
    for y in 0...SIZE {
        for x in 0...SIZE {
            if state[y][x] != 0 && state[y][x] != goalState[y][x] {
                heuristic = heuristic + 1
            }
        }
    }
    return heuristic
}

func euclidean(_ state: [[Int]]) -> Int {
    // p = (p1, p2) and q = (q1, q2)
    var heuristic = 0.0
    for i in 0...SIZE {
        for j in 0...SIZE {
            if (state[i][j] == 0) {
                continue
            }
            let (row, col) = findCoordinates(state[i][j], in: goalState)!
            
            heuristic += sqrt(pow((Double(row - i)), 2) + pow((Double(col - j)), 2))
            print("New coord in goal:: row-> ", row, "  col-> ", col, "value: ", state[i][j], "absRow  \(pow((Double(row - i)), 2))  absCol \(pow((Double(col - j)), 2))  total: \(heuristic)")
        }
    }
    print("SQRT: ", heuristic)
    return Int(sqrt(heuristic));
}


func getHeuristics() -> Dictionary<Heuristic, ([[Int]]) -> Int> {
    var heuristicsAvailable: Dictionary<Heuristic, ([[Int]]) -> Int> = [:]
    heuristicsAvailable[.MANHATTAN] = manhattan
    heuristicsAvailable[.MISSPLACED] = missplaced
    return heuristicsAvailable
}
