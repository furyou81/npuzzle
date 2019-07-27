//
//  main.swift
//  testnpuzzle
//
//  Created by Eric MERABET on 7/24/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

enum ArgsAlgorithm: String {
    case ASTAR = "astar"
    case UNIFORM = "uniform"
    case GREEDY = "greedy"
}

enum ArgsHeuristic: String {
    case MISPLACED = "misplaced"
    case EUCLIDEAN = "euclidean"
    case MANHATTAN = "manhattan"
}


var error: Bool = false
var argsAlgo: Algorithm = Algorithm.ASTAR
var argsHeuri: Heuristic = Heuristic.MANHATTAN
var argsWeight: Int = 1
var path: String = ""

let nbArgs = CommandLine.arguments.count
var skip: Bool = false
for (index, argument) in CommandLine.arguments.enumerated() {
    if skip || index < 1 {
        skip = false
        continue
    }
    switch argument {
    case "-h":
        if index + 1 < nbArgs {
            switch CommandLine.arguments[index + 1] {
                case ArgsHeuristic.MISPLACED.rawValue:
                argsHeuri = .MISSPLACED
                break
                case ArgsHeuristic.EUCLIDEAN.rawValue:
                argsHeuri = .EUCLIDEAN
                break
                case ArgsHeuristic.MANHATTAN.rawValue:
                argsHeuri = .MANHATTAN
                break
                default:
                print("the heuristic must be one among: misplaced, euclidean or manhattan")
                error = true
            }
        } else {
            print("if you put the -a flag, you need to specify an heuristic: misplaced, euclidean or manhattan")
            error = true
        }
        skip = true
        continue
    case "-a":
        if index + 1 < nbArgs {
            switch CommandLine.arguments[index + 1] {
            case ArgsAlgorithm.ASTAR.rawValue:
                argsAlgo = .ASTAR
                break
            case ArgsAlgorithm.UNIFORM.rawValue:
                argsHeuri = .UNIFORM_COST
                break
            case ArgsAlgorithm.GREEDY.rawValue:
                argsAlgo = .GREEDY
                break
            default:
                print("the algorithm must be one among: astar, uniform or greedy")
                error = true
            }
        } else {
            print("if you put the -a flag, you need to specify an algorithm: astar, uniform or greedy")
            error = true
        }
        skip = true
        continue
    case "-w":
        if index + 1 < nbArgs {
            if let w = Int(CommandLine.arguments[index + 1]) {
                if w > 0 {
                    argsWeight = w
                } else {
                    print("the weight must be a positive integer")
                    error = true
                }
            } else {
                print("the weight must be a positive integer")
                error = true
            }
        } else {
            print("if you put the -w flag, you need to specify a weight which should be a positive integer")
            error = true
        }
        skip = true
        continue
    default:
        if path == "" {
            path = argument
        } else {
            print("USAGE: filePath [-a astar, uniform or greedy] [-h misplaced, euclidean or manhattan]")
            error = true
        }
    }
}

if path == "" {
    print("you must specify a file path")
    print("USAGE: filePath [-a astar, uniform or greedy] [-h misplaced, euclidean or manhattan]")
    error = true
}

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
