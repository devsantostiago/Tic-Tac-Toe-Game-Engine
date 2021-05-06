//
//  Game.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation

protocol GameDelegate {
    func didUpdateBoard (_ board: [PlayerSymbol?])
    func didFoundWinner (_ winner: PlayerSymbol?)
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
        playerTwo = Player(symbol: firstPlayerSymbol.getOppositeSymbol())
        board = getCleanGameBoard()
    }
    
    init(board: [PlayerSymbol?], delegate: GameDelegate, nextPlayer: PlayerSymbol){
        self.board = board
        self.delegate = delegate
        self.playerToStart = nextPlayer
        self.currentPlayer = nextPlayer
        playerOne = Player(symbol: nextPlayer)
        playerTwo = Player(symbol: nextPlayer.getOppositeSymbol())
    }
    
    private func getCleanGameBoard() -> [PlayerSymbol?] {
        return  [PlayerSymbol?](repeating: nil, count: 9)
    }
    
    func select(square: Int) -> Bool {
        if board[square] != nil{
            return false
        }
        board[square] = currentPlayer
        updateCurrentPlayer()
        delegate.didUpdateBoard(board)
        checkIfWinnerIsFound()
        return true
    }
    
    func newRound() {
        updatePlayerToStart()
        board = getCleanGameBoard()
        delegate.didUpdateBoard(board)
    }
    
    func restart(firstPlayerSymbol: PlayerSymbol) {
        playerToStart = firstPlayerSymbol
        currentPlayer = firstPlayerSymbol
        playerOne = Player(symbol: firstPlayerSymbol)
        playerTwo = Player(symbol: firstPlayerSymbol.getOppositeSymbol())
        board = getCleanGameBoard()
        delegate.didUpdateBoard(board)
    }
    
    private func updatePlayerToStart() {
        playerToStart = playerToStart.getOppositeSymbol()
    }
    
    func getPlayerToStart() -> String {
        return String(playerToStart.rawValue)
    }
    
    private func updateCurrentPlayer() {
        currentPlayer = currentPlayer.getOppositeSymbol()
    }
    
    func getPlayerOneScore() -> String {
        return String(playerOne.score)
    }

    func getPlayerTwoScore() -> String {
        return String(playerTwo.score)
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
    
    //MARK: - End game conditions
    private func checkIfWinnerIsFound() {
        if checkWinnerInLines() { return }
        if checkWinnerInColumns() { return }
        if checkWinnerInDiagonals() { return }
        checkDraw()
    }
    
    private func checkDraw() {
        let freeSpaces = self.board.filter { return $0 == .none }
        if freeSpaces.count == 0 {
            delegate.didFoundWinner(nil)
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
    
    private func checkWinnerInLines() -> Bool {
        for i in 0...2 {
            let elementsToCheck = constructBoardSquaresArray(with: [3*i,3*i+1,3*i+2])
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
}
