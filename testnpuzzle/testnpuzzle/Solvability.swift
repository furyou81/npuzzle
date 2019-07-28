//
//  Solvability.swift
//  testnpuzzle
//
//  Created by Leo-taro FUJIMOTO on 7/28/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

extension Array where Element == Array<Int> {
    var flatArray: [Int] {
        return self.flatMap({$0})
    }
    var flatArrayCoord: Dictionary<Int, Int> {
        var coordinates: Dictionary<Int, Int> = [:]
        for (index, number) in flatArray.enumerated() {
            coordinates[number] = index
        }
        return coordinates
    }
}

func checkIfSolvable(state: [[Int]], goalState: [[Int]], storedGoalCoordinates: Dictionary<Int, (row: Int, col: Int)>, size: Int, printMessage: Bool = false) -> Bool {
    let flatState = state.flatArray
    let goalCoord = goalState.flatArrayCoord
//        let flatState = [[12, 1, 10, 2],
//        [7, 11, 4, 14],
//        [5, 0, 9, 15],
//        [8, 13, 6, 3]].flatArray
//    let goalCoord = [[1, 2, 3, 4],
//                     [5, 6, 7, 8],
//                     [9, 10, 11, 12],
//                     [13, 14, 15, 0]].flatArrayCoord
    var inversions = 0
    let length = flatState.count - 1
    for i in 0...length {
        var tmp = 0
        if flatState[i] == 0 {
            continue
        }
        for j in i...length {
            if goalCoord[flatState[i]]! > goalCoord[flatState[j]]! && flatState[j] != 0 {
                print("INV", flatState[i], goalCoord[flatState[i]]!, goalCoord[flatState[j]]!, flatState[j])
                inversions = inversions + 1
                tmp = tmp + 1
            }
        }
        print("FOR", flatState[i], tmp)
    }
    print("TOTAL", inversions)
    let isOddSize: Bool = (size + 1) % 2 == 1
    let isOddInversions: Bool = inversions % 2 == 1
    print("BLANK POS", size + 1, (storedGoalCoordinates[0]!.row), (size + 1 - (storedGoalCoordinates[0]!.row)) % 2 == 1)
    let isOddPosBlank:Bool = (size + 1 - (storedGoalCoordinates[0]!.row)) % 2 == 1
    print(isOddPosBlank, size + 1, (storedGoalCoordinates[0]!.row))
    print((!isOddSize && (isOddInversions && !isOddPosBlank)), !isOddSize, isOddInversions, !isOddPosBlank)
    if (isOddSize && !isOddInversions) || (!isOddSize && (isOddInversions && !isOddPosBlank) || (!isOddInversions && isOddPosBlank)) {
        print("SOLVABLE")
        if inversions > 30 {
            return false
        }
//        exit(0)
        return true
    }
//    if printMessage {
        print("NOT SOLVABLE")
//    }
//    exit(0)
    return false
}

