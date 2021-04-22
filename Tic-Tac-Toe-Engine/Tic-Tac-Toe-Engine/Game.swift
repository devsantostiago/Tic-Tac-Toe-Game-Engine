//
//  Game.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation

enum Player: String {
    case cross  = "X"
    case circle = "O"
}

class Game {
    
    private var playerOneScore = 0
    private var playerTwoScore = 0
    
    private var currentPlayer: Player = .cross
    var didUpdateBoard: ((_ board: String) -> Void)?
    var didFoundWinner: ((_ winner: Player) -> Void)?
    
    private var board = [Player?](repeating: nil, count: 9)
    
    func select(square: Int) -> Bool{
        if board[square] != nil{
            return false
        }

        board[square] = currentPlayer
        updateCurrentPlayer()
        didFoundWinner?(Player.cross)
        return true
    }
    
    private func updateCurrentPlayer() {
        switch currentPlayer {
        case .circle:
            currentPlayer = .cross
        case .cross:
            currentPlayer = .circle
        }
    }
    
    func getPlayerOneScore() -> String {
        return String(playerOneScore)
    }

    func getPlayerTwoScore() -> String {
        return String(playerTwoScore)
    }
    
    
}

//MARK:- Printing game board logic
extension Game {
    
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
        guard let boardPosition = board[i] else {
            return "."
        }
        return boardPosition.rawValue
    }
    
    private func isEndOfLine(i: Int) -> Bool {
        return i == 3 || i == 6
    }
}
