//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

//npuzzleGenerator(size: 4)

parseArgs()







if !error {
    do {
        var state: [[Int]]
        if randomlyGenerated {
            state = npuzzleGenerator(size: choosenSize, solvable: solvable)
        } else {
            let parseFile = ParseFile()
            let fileName = (path as NSString).lastPathComponent
            let directoryPath = (path as NSString).deletingLastPathComponent
            state = try parseFile.parseState(fileName: fileName, directoryPath: directoryPath)
        }
        print("STATE", state)
        let size = state.count - 1
        let goalState = findGoal(startingState: state, size: size)
        print("GOAL",goalState)
        let storedGoalCoordinates = storeGoalCoordinates(goalState: goalState, size: size)
        if checkIfSolvable(state: state, goalState: goalState, storedGoalCoordinates: storedGoalCoordinates, size: size, printMessage: true) {
            let engine = Engine(startState: state, goalState: goalState, storedGoalCoordinates: storedGoalCoordinates, choosenHeuristic: .MANHATTAN, choosenAlgorithm: .ASTAR, weight: argsWeight)
            
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
