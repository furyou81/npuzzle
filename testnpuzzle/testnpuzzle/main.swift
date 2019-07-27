//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

parseArgs()

if !error {
    let parseFile = ParseFile()
    let fileName = (path as NSString).lastPathComponent
    let directoryPath = (path as NSString).deletingLastPathComponent
    
    do {
        let state = try parseFile.parseState(fileName: fileName, directoryPath: directoryPath)
        let engine = Engine(startState: state!, choosenHeuristic: .MANHATTAN, choosenAlgorithm: .ASTAR)
        
        let startTime = CFAbsoluteTimeGetCurrent()
        print("started")
        
        engine.execute()
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for : \(timeElapsed) s.")
    } catch ParseError.parseError(let error){
        print(error)
    }
    catch {
        print("WRONG PATH")
    }
}
