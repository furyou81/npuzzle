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
    case UNIFORM_COST
}

func manhattan(SIZE: Int, storedGoalCoordinates: Dictionary<Int, (row: Int, col: Int)>) -> (_ state: [[Int]]) -> Int {
    return {state in
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
}

func missplaced(SIZE: Int, goalState: [[Int]]) -> (_ state: [[Int]]) -> Int{
    return {state in
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
}

func euclidean(SIZE: Int, goalState: [[Int]]) -> (_ state: [[Int]]) -> Int {
    return {state in
        // p = (p1, p2) and q = (q1, q2)
        var distance = 0
        for i in 0...SIZE {
            for j in 0...SIZE {
                if (state[i][j] == 0) {
                    continue
                }
                let (row, col) = Engine.findCoordinates(state[i][j], in: goalState, SIZE: SIZE)!
                
                distance += max(abs(row - i), abs(col - j))
                print("New coord in goal:: row-> ", row, "  col-> ", col, "value: ", state[i][j], "absRow  \(abs(row - i))  absCol \(abs(col - j))  total: \(distance)")
            }
        }
        return distance;
    }
}

func uniformCost(_ state: [[Int]]) -> Int {
    return 0;
}


func getHeuristics(SIZE: Int, goalState: [[Int]], storedGoalCoordinates: Dictionary<Int, (row: Int, col: Int)>) -> Dictionary<Heuristic, ([[Int]]) -> Int> {
    var heuristicsAvailable: Dictionary<Heuristic, ([[Int]]) -> Int> = [:]
    heuristicsAvailable[.MANHATTAN] = manhattan(SIZE: SIZE, storedGoalCoordinates: storedGoalCoordinates)
    heuristicsAvailable[.MISSPLACED] = missplaced(SIZE: SIZE, goalState: goalState)
    heuristicsAvailable[.EUCLIDEAN] = euclidean(SIZE: SIZE, goalState: goalState)
    heuristicsAvailable[.UNIFORM_COST] = uniformCost
    return heuristicsAvailable
}
