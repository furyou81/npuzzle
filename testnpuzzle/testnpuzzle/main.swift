//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

//parseArgs()


private func findGoal(startingState: [[Int]], size: Int) -> [[Int]] {
    var goal: [[Int]] = startingState
    var numbers: [Int] = goal.flatMap({
        $0
    }).filter({
        $0 != 0
    })
    numbers = numbers.sorted(by: {$0 < $1})
    var numberIndex = 0
    var x = 0
    for y in 0...(size / 2) {
        for xx in (x)...(size - x) {
            goal[y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : 0
            numberIndex = numberIndex + 1
        }
        if (y + 1) <= (size - y - 1) {
            for yy in (y + 1)...(size - y - 1) {
                goal[yy][size - x] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                numberIndex = numberIndex + 1
            }
        }
        for xx in (x...(size - x)).reversed() {
            goal[size - y][xx] = numberIndex < numbers.count ? numbers[numberIndex] : 0
            numberIndex = numberIndex + 1
        }
        if (y + 1) <= (size - y - 1) {
            for yy in ((y + 1 )...(size - y - 1)).reversed() {
                goal[yy][x] = numberIndex < numbers.count ? numbers[numberIndex] : 0
                numberIndex = numberIndex + 1
            }
        }
        x = x + 1
    }
    return goal
}

private func storeGoalCoordinates(goalState: [[Int]], size: Int) -> Dictionary<Int, (row: Int, col: Int)> {
    var storedCoord: Dictionary<Int, (row: Int, col: Int)> = [:]
    
    for i in 0...size {
        for j in 0...size {
            storedCoord[goalState[i][j]] = (row: i, col: j)
        }
    }
    return storedCoord
}

func checkNumberOfInversions(state: [[Int]], goalState: [[Int]], size: Int, i: Int, j: Int) -> Int {
    //    for x in 0...size {
    //        for y in
    //    }
    return 0
}

func checkIfSolvable(state: [[Int]], goalState: [[Int]], size: Int) -> Bool {
    print("CHECKING SOLVABILITY")
    var numberOfInvertions: Int = 0
    for i in 0...size {
        for j in 0...size {
            
        }
    }
    return false
}

if !error {
    let parseFile = ParseFile()
    let fileName = (path as NSString).lastPathComponent
    let directoryPath = (path as NSString).deletingLastPathComponent
    do {
        let state = try parseFile.parseState(fileName: fileName, directoryPath: directoryPath)
        let size = state.count - 1
        let goalState = findGoal(startingState: state, size: size)
        let storedGoalCoordinates = storeGoalCoordinates(goalState: goalState, size: size)
        if checkIfSolvable(state: state, goalState: goalState, size: size) {
            let engine = Engine(startState: state, goalState: goalState, storedGoalCoordinates: storedGoalCoordinates, choosenHeuristic: .MANHATTAN, choosenAlgorithm: .ASTAR)
            
            let startTime = CFAbsoluteTimeGetCurrent()
            print("started")
            
            engine.execute()
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Time elapsed for : \(timeElapsed) s.")
        }
    } catch ParseError.parseError(let error){
        print(error)
    }
    catch {
        print("WRONG PATH")
    }
}

func bypassParsing() {
    
    let state = [
        [0, 2, 3],
        [1, 4, 5],
        [8, 7, 6]
    ]
    
    let size = state.count - 1
    let goalState = [
        [1, 2, 3],
        [8, 0, 4],
        [7, 6, 5],
    ]
    let storedGoalCoordinates = storeGoalCoordinates(goalState: goalState, size: size)
    
    
    
    let engine = Engine(startState: state, goalState: goalState, storedGoalCoordinates: storedGoalCoordinates, choosenHeuristic: .XY, choosenAlgorithm: .ASTAR)
    
    let startTime = CFAbsoluteTimeGetCurrent()
    print("started")
    
    engine.execute()
    
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for : \(timeElapsed) s.")
}

bypassParsing()
