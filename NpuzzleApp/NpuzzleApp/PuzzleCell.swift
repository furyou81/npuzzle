//
//  PuzzleCell.swift
//  NpuzzleApp
//
//  Created by Leo-taro FUJIMOTO on 7/29/19.
//  Copyright © 2019 Leo-taro FUJIMOTO. All rights reserved.
//

import UIKit

class PuzzleCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    
    var myValue : (Int)? {
        didSet {
            valueLabel.text = String(describing: myValue!)
        }
    }
    
    
}
