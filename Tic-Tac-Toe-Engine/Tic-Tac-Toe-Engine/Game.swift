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
    
    func select(square: Int) -> Bool {
        if board[square] != nil{
            return false
        }

        board[square] = currentPlayer
        updateCurrentPlayer()
        didUpdateBoard?(getBoardState())
        checkIfWinnerIsFound()
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

    private func checkIfWinnerIsFound() {
        if checkWinnerInLines() {
            return
        }
        if checkWinnerInColumns() {
            return
        }
        if checkWinnerInDiagonals() {
            return
        }
    }

    private func checkWinnerInDiagonals() -> Bool {
        if checkLeftDiagonal() {
            return true
        }
        if checkRightDiagonal() {
            return true
        }
        return false
    }
    
    private func checkRightDiagonal() -> Bool {
        let elementsToCheck = constructBoardSquaresArray(with: [2,4,6])
        if checkWinnerInArray(elementsToCheck) {
            return true
        }
        return false
    }
    
    private func checkLeftDiagonal() -> Bool {
        let elementsToCheck = constructBoardSquaresArray(with: [0,4,8])
        if checkWinnerInArray(elementsToCheck) {
            return true
        }
        return false
    }
    
    private func checkWinnerInColumns() -> Bool {
        for i in 0...2 {
            let elementsToCheck = constructBoardSquaresArray(with: [i,i+3,i+6])
            if checkWinnerInArray(elementsToCheck) {
                return true
            }
        }
        return false
    }
    
    private func constructBoardSquaresArray(with elements: [Int]) -> [Player?] {
        var boardSquares = [Player?]()
        for element in elements {
            boardSquares.append(board[element])
        }
        return boardSquares
    }
    
    private func checkWinnerInLines() -> Bool {
        for i in 0...2 {
            let elementsToCheck = constructBoardSquaresArray(with: [3*i,3*i+1,3*i+2])
            if checkWinnerInArray(elementsToCheck) {
                return true
            }
        }
        return false
    }
    
    private func checkWinnerInArray(_ array: [Player?]) -> Bool {
        if array.contains(.none) {
            return false
        }
        let firstElement = array[0]
        for j in 1...2 {
            if firstElement != array[j] {
                return false
            }
        }
        self.notifyClientWithWinner(firstElement!)
        return true
    }
    
    private func notifyClientWithWinner(_ winner: Player) {
        self.didFoundWinner?(winner)
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
