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
        didUpdateBoard?(getBoardState())
        foundWinner()
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

    func foundWinner(){
        checkWinnerInLines()
        checkWinnerInColumns()
        checkWinnerInDiagonal()
    }

    private func checkWinnerInDiagonal(){
        checkLeftDiagonal()
        checkRightDiagonal()
    }
    
    private func checkRightDiagonal() {
        var rightDiagonal = [Player?]()
        rightDiagonal.append(board[2])
        rightDiagonal.append(board[4])
        rightDiagonal.append(board[6])
        checkWinnerInArray(rightDiagonal)
    }
    
    private func checkLeftDiagonal() {
        var leftDiagonal = [Player?]()
        leftDiagonal.append(board[0])
        leftDiagonal.append(board[4])
        leftDiagonal.append(board[8])
        checkWinnerInArray(leftDiagonal)
    }
    
    private func checkWinnerInColumns() {
        for i in 0...2 {
            var boardColumn = [Player?]()
            boardColumn.append(board[i])
            boardColumn.append(board[3+i])
            boardColumn.append(board[6+i])
            checkWinnerInArray(boardColumn)
        }
    }
    
    private func checkWinnerInLines() {
        for i in 0...2 {
            let boardLine = Array(board[(i*3)...(i*3+2)])
            checkWinnerInArray(boardLine)
        }
    }
    
    private func checkWinnerInArray(_ array: [Player?]){
        if array.contains(.none) {
            return
        }
        let firstElement = array[0]
        for j in 1...2 {
            if firstElement != array[j] {
                return
            }
        }
        self.didFoundWinner?(firstElement!)
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
