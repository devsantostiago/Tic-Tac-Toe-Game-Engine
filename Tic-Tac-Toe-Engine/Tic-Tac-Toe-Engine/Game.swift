//
//  Game.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation

enum PlayerSymbol: String {
    case cross  = "X"
    case circle = "O"
}

struct Player {
    var symbol: PlayerSymbol
    var score: Int = 0
    
    init(symbol: PlayerSymbol) {
        self.symbol = symbol
    }
}

protocol GameDelegate {
    func didUpdateBoard (_ board: String)
    func didFoundWinner (_ winner: PlayerSymbol)
}

class Game {
    
    private var playerOne: Player
    private var playerTwo: Player
    
    private var playerToStart: PlayerSymbol = .circle
    private var currentPlayer: PlayerSymbol = .cross
    
    private let delegate: GameDelegate!
    
    private var board: [PlayerSymbol?]!
    
    init(firstPlayerSymbol: PlayerSymbol = .circle, delegate: GameDelegate) {
        self.delegate = delegate
        playerToStart = firstPlayerSymbol
        currentPlayer = firstPlayerSymbol
        playerOne = Player(symbol: firstPlayerSymbol)
        playerTwo = Player(symbol: Game.getOppositePlayerSymbol(firstPlayerSymbol: firstPlayerSymbol))
        board = Game.getCleanGameBoard()
    }
    
    init(board: [PlayerSymbol?], delegate: GameDelegate, nextPlayer: PlayerSymbol){
        self.board = board
        self.delegate = delegate
        self.playerToStart = nextPlayer
        self.currentPlayer = nextPlayer
        playerOne = Player(symbol: nextPlayer)
        playerTwo = Player(symbol: Game.getOppositePlayerSymbol(firstPlayerSymbol: nextPlayer))
    }
    
    class private func getCleanGameBoard() -> [PlayerSymbol?] {
        return  [PlayerSymbol?](repeating: nil, count: 9)
    }
    
    class private func getOppositePlayerSymbol(firstPlayerSymbol: PlayerSymbol) -> PlayerSymbol {
        if firstPlayerSymbol == .circle {
            return .cross
        }
        return .circle
    }
    
    func select(square: Int) -> Bool {
        if board[square] != nil{
            return false
        }

        board[square] = currentPlayer
        updateCurrentPlayer()
        delegate.didUpdateBoard(getBoardState())
        checkIfWinnerIsFound()
        return true
    }
    
    func newRound() {
        updatePlayerToStart()
        board = Game.getCleanGameBoard()
        delegate.didUpdateBoard(getBoardState())
    }
    
    func restart(firstPlayerSymbol: PlayerSymbol) {
        playerToStart = firstPlayerSymbol
        currentPlayer = firstPlayerSymbol
        playerOne = Player(symbol: firstPlayerSymbol)
        playerTwo = Player(symbol: Game.getOppositePlayerSymbol(firstPlayerSymbol: firstPlayerSymbol))
        board = Game.getCleanGameBoard()
        delegate.didUpdateBoard(getBoardState())
    }
    
    private func updatePlayerToStart() {
        if playerToStart == .circle {
            playerToStart = .cross
        } else {
            playerToStart = .circle
        }
    }
    
    func getPlayerToStart() -> String {
        return String(playerToStart.rawValue)
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
        return String(playerOne.score)
    }

    func getPlayerTwoScore() -> String {
        return String(playerTwo.score)
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
    
    private func constructBoardSquaresArray(with elements: [Int]) -> [PlayerSymbol?] {
        var boardSquares = [PlayerSymbol?]()
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
    
    private func checkWinnerInArray(_ array: [PlayerSymbol?]) -> Bool {
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
    
    private func notifyClientWithWinner(_ winner: PlayerSymbol) {
        delegate.didFoundWinner(winner)
        self.updatePlayerScore(with: winner)
    }
    
    private func updatePlayerScore(with symbol: PlayerSymbol) {
        if playerOne.symbol == symbol{
            playerOne.score += 1
        }else {
            playerTwo.score += 1
        }
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
