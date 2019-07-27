//
//  ParseFile.swift
//  testnpuzzle
//
//  Created by Leo-taro FUJIMOTO on 7/27/19.
//  Copyright © 2019 Eric MERABET. All rights reserved.
//

import Foundation

class ParseFile {
    var filePaths: [String] = []
    let path: String
    
    init() {
        let fm = FileManager.default
        self.path = Bundle.main.resourcePath! + "/input_files"
        do {
            self.filePaths = try fm.contentsOfDirectory(atPath: path)
        } catch {
            print("ERROR OPENING DIRECTORY")
        }
    }
    
    func printFile(fileName: String) {
        do {
            let text = try String(contentsOfFile: self.path + "/" + fileName, encoding: .utf8)
            print(text)
        }
        catch {
            print("ERROR READING FILE")
        }
    }
    
    func parseState(fileName: String) {
        
    }
}
