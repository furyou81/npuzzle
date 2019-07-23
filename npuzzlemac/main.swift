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

let mockInitialStateb = [
    [4, 2, 3],
    [6, nil, 5],
    [8, 7, 1]
]

let mockInitialStatec = [
    [4, 6, 5],
    [nil, 2, 1],
    [7, 8, 3]
]

let mockInitialState2 = [
    [15, 6, 8, 10],
    [14, 13, 2, 3],
    [9, 11, nil, 1],
    [4, 7, 12, 5]
]

let mockInitialState5 = [
    [14, 12, 10, 9],
    [1, 11, 3, 5],
    [nil, 7, 4, 6],
    [13, 8, 2, 15]
]

let easy = [
    [1, 2, 3, 4],
    [12, nil, 13, 5],
    [11, 15, 14, 6],
    [10, 9, 8, 7]
]

let medium = [
    [15, 13, 5, 3],
    [14, 8, 1, 10],
    [2, 7, nil, 4],
    [6, 9, 12, 11]
]

let medium3 = [
    [6, 9, 12, 3],
    [1, 14, 11, 2],
    [7, 4, 8, 15],
    [nil, 13, 10, 5]
]

let medium2 = [
    [7, 8, 4, 10],
    [14, 11, 15, 13],
    [12, 3, nil, 2],
    [5, 6, 9, 1]
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

//var testQueue = PrioriryQueue();
//
//var fakeState: [[Int?]] = [];
//var node1 = Node(state: fakeState)
//node1.scoreH = 10
//
//var node2 = Node(state: fakeState)
//node2.scoreH = 5
//
//var node3 = Node(state: fakeState)
//node3.scoreH = 2
//
//var node4 = Node(state: fakeState)
//node4.scoreH = 1
//
//var node5 = Node(state: fakeState)
//node5.scoreH = 10
//
//testQueue.enqueue(node: node1)
//testQueue.enqueue(node: node2)
//testQueue.enqueue(node: node3)
//testQueue.enqueue(node: node4)
//
//print("Enqueue Result: ", testQueue.queueInt, " Expected: ", "12510");
//
//testQueue.enqueue(node: node4)
//testQueue.enqueue(node: node5)
//print("Enqueue Result: ", testQueue.queueInt, " Expected: ", "121105");
//
//
//var lol = testQueue.dequeue()
//
//print("Deqeeue Result: ", testQueue.queueInt, " Expected: ", "12105");
//lol = testQueue.dequeue()
//lol = testQueue.dequeue()
//lol = testQueue.dequeue()
//lol = testQueue.dequeue()
//print("Deqeeue Result: ", testQueue.queueInt, " Expected: ", "2105");
//var stop = 10;








let startTime = CFAbsoluteTimeGetCurrent()

let rootNode = Node(state: mockInitialState)

let engine = Engine(rootNode: rootNode, heuristic: .manhattan)
engine.execute()

let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Time elapsed for : \(timeElapsed) s.")

