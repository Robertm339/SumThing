//
//  Board.swift
//  SumThing
//
//  Created by Robert Martinez on 11/20/22.
//

import Foundation

enum Difficulty: CaseIterable {
    case easy, medium, tricky, taxing, nightmare
}

class Board: ObservableObject {
    var exampleCells = [[Int]]()
    @Published var userCells = [[Int]]()
    
    @Published var selectedRow = 0
    @Published var selectedCol = 0
    
    var isSolved: Bool {
        for i in 0..<exampleCells.count {
            let exampleSum = exampleCells[i].reduce(0, +)
            let userSum = userCells[i].reduce(0, +)
            if exampleSum != userSum { return false }
        }
        
        for i in 0..<exampleCells[0].count {
            let exampleSum = exampleCells.reduce(0) { $0 + $1[i] }
            let userSum = userCells.reduce(0) { $0 + $1[i] }
            if exampleSum != userSum { return false }
        }
        
        for row in userCells {
            for col in row {
                if col == 0 { return false }
            }
        }
        
        return true
    }
    
    init(_ difficulty: Difficulty) {
        create(difficulty)
    }
    
    func create(_ difficulty: Difficulty) {
        selectedRow = 0
        selectedCol = 0
        
        let size: Int
        let maxNumber: Int
        
        switch difficulty {
        case .easy:
            size = 2
            maxNumber = 4
        case .medium:
            size = 3
            maxNumber = 4
        case .tricky:
            size = 4
            maxNumber = 4
        case .taxing:
            size = 5
            maxNumber = 6
        case .nightmare:
            size = 5
            maxNumber = 8
        }
        
        exampleCells = (0..<size).map { _ in
            (0..<size).map { _ in
                Int.random(in: 1...maxNumber)
            }
        }
        
        userCells = Array(repeating: Array(repeating: 0, count: size), count: size)
    }
    
    func enter(_ number: Int) {
        if userCells[selectedRow][selectedCol] == number {
            userCells[selectedRow][selectedCol] = 0
        } else {
            userCells[selectedRow][selectedCol] = number
            
            if selectedCol < exampleCells[0].count - 1 {
                selectedCol += 1
            } else if selectedRow < exampleCells.count - 1 {
                selectedRow += 1
                selectedCol = 0
            }
        }
    }
    
    func hint(for number: Int) -> String {
        let currentValue = userCells[selectedRow][selectedCol]
        
        if currentValue == number {
            return "Clear row \(selectedRow + 1) column \(selectedCol + 1)"
        } else {
            return "Set row \(selectedRow + 1) column \(selectedCol + 1) to \(number)"
        }
    }
}

