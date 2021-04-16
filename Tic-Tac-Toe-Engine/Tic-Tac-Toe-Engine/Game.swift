//
//  Game.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation

enum SquareStatus: String {
    case cross  = "X"
    case circle = "O"
    case free   = "."
}

class Game {
    
    var playerOneScore = 0
    var playerTwoScore = 0
    
    var board = [SquareStatus](repeating: .free, count: 9)
    
    func select(square: Int){
        board[square] = .cross
    }
    

    //MARK:- Printing game board logic
    
    func getBoardState() -> String {
        var boardString = ""
        
        for i in 0..<board.count {
            if isEndOfLine(i: i) {
                boardString.append("\n")
            }
            boardString.append(getSymbolForPosition(i: i))
            if isNotEndOfLine(i) {
                boardString.append(" ")
            }
        }
        
        return boardString
    }
    
    fileprivate func isNotEndOfLine(_ i: Int) -> Bool {
        return i != 2 && i != 5 && i != 8
    }
    
    private func getSymbolForPosition(i: Int) -> String {
        return board[i].rawValue
    }
    
    private func isEndOfLine(i: Int) -> Bool {
        return i == 3 || i == 6
    }
}
