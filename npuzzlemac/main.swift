//
//  main.swift
//  npuzzlemac
//
//  Created by Leo-taro FUJIMOTO on 7/22/19.
//  Copyright © 2019 Leo-taro FUJIMOTO. All rights reserved.
//

import Foundation

let mockInitialState0 = [
    [3, 2,],
    [1, nil],
]

let mockInitialState = [
    [nil, 2, 3],
    [1, 4, 5],
    [8, 7, 6]
]

let mockInitialState2 = [
    [4, 2, 3, 9],
    [1, nil, 5, 10],
    [8, 7, 6, 11],
    [12, 13, 14, 15]
]

let mockInitialState3 = [
    [4, 2, 3, 9, 16],
    [1, nil, 5, 10, 17],
    [8, 7, 6, 11, 18],
    [12, 13, 14, 15, 19],
    [20, 21, 22, 23, 24]
]

let mockInitialState4 = [
    [4, 2, 3, 9, 16, 25],
    [1, nil, 5, 10, 17, 26],
    [8, 7, 6, 11, 18, 27],
    [12, 13, 14, 15, 19, 28],
    [20, 21, 22, 23, 24, 29],
    [30, 31, 32, 33, 34, 35]
]

let rootNode = Node(state: mockInitialState)

let engine = Engine(rootNode: rootNode, heuristic: .misplacedTiles)
engine.resolve()
