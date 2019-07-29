//
//  SolveViewController.swift
//  NpuzzleApp
//
//  Created by Leo-taro FUJIMOTO on 7/29/19.
//  Copyright © 2019 Leo-taro FUJIMOTO. All rights reserved.
//

import UIKit

class SolveViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var values: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
    var moves: [Move] = []
    
    
    var argsAlgo: Algorithm = Algorithm.ASTAR
    var argsHeuri: Heuristic = Heuristic.MANHATTAN
    var sizeChoosen: Int = 3
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! PuzzleCell
        cell.backgroundColor = .red
        cell.myValue = values[indexPath.row]
        return cell
    }

    @IBAction func solveButtonPressed(_ sender: Any) {
        print("Solve pressed")
        let size = self.sizeChoosen
        let zeroPos = values.index(of: 0)
        let from = IndexPath(row: zeroPos!, section: 0)
            increaseLabel(from: from, index: 0, size: size)
    }
    
    
    func increaseLabel(from: IndexPath, index: Int, size: Int) {
        let move = moves[index]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            var to: IndexPath
            print("MOVE", move)
            switch move {
            case .DOWN:
                to = IndexPath(row: from.row + size, section: 0)
                self.collectionView.moveItem(at: from, to: to)
                self.collectionView.moveItem(at: IndexPath(row: to.row - 1, section: 0), to: from)
                break
            case .UP:
                to = IndexPath(row: from.row - size, section: 0)
                self.collectionView.moveItem(at: from, to: to)
                self.collectionView.moveItem(at: IndexPath(row: to.row + 1, section: 0), to: from)
                break
            case .LEFT:
                to = IndexPath(row: from.row - 1, section: 0)
                self.collectionView.moveItem(at: from, to: to)
                break
            case .RIGHT:
                to = IndexPath(row: from.row + 1, section: 0)
                self.collectionView.moveItem(at: from, to: to)
                break
            }
            print("From: ", from, " to: ", to)
            if index < self.moves.count - 1 {
                self.increaseLabel(from: to, index: index + 1, size: size)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var state: [[Int]]

        let argsWeight: Int = 50
        state = npuzzleGenerator(size: self.sizeChoosen, solvable: true)
        values = state.flatArray
        let size = state.count - 1
        let goalState = findGoal(startingState: state, size: size)
        let storedGoalCoordinates = storeGoalCoordinates(goalState: goalState, size: size)
        if checkIfSolvable(state: state, goalState: goalState, storedGoalCoordinates: storedGoalCoordinates, size: size, printMessage: true) {
            
            let engine = Engine(startState: state, goalState: goalState, storedGoalCoordinates: storedGoalCoordinates, choosenHeuristic: .MANHATTAN, choosenAlgorithm: .ASTAR, weight: argsWeight)
            print("started")
            moves = engine.execute()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
