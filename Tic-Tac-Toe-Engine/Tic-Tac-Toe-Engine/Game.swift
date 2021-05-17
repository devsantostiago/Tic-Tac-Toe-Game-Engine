//
//  Game.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation

enum ResumeGameError: Error {
    case invalidNextPlayer
    case invalidInitialBoardState
    case invalidBoardSize
}

class Game {
    
    private var playerOne: Player
    private var playerTwo: Player
    private var playerToStart: PlayerSymbol = .circle
    private var currentPlayer: PlayerSymbol = .cross
    
    var didUpdateBoard: ((_ board: Board) -> Void)?
    var didFoundWinner: ((_ winner: PlayerSymbol?) -> Void)?
    
    private var board = Board()
    
    init(firstPlayerSymbol: PlayerSymbol = .circle) {
        playerToStart = firstPlayerSymbol
        currentPlayer = firstPlayerSymbol
        playerOne = Player(symbol: firstPlayerSymbol)
        playerTwo = Player(symbol: firstPlayerSymbol.getOppositeSymbol())
    }
    
    //MARK: - Resume game logic
    
    init(board: [PlayerSymbol?], nextPlayer: PlayerSymbol) throws {
        let currentBoard = try Board(board: board)
        try Game.validateInitialConditions(board: currentBoard, nextPlayer: nextPlayer)
        self.board = currentBoard
        self.playerToStart = nextPlayer
        self.currentPlayer = nextPlayer
        self.playerOne = Player(symbol: nextPlayer)
        self.playerTwo = Player(symbol: nextPlayer.getOppositeSymbol())
    }
    
    private class func validateInitialConditions(board: Board, nextPlayer: PlayerSymbol) throws {
        if Game.areNoFreeSpacesIn(board: board){
            throw ResumeGameError.invalidInitialBoardState
        }
        if Game.playerSelectedMoreSquaresThanAllowed(board: board) {
            throw ResumeGameError.invalidInitialBoardState
        }
        if Game.isInvalidNextPlayer(board: board, nextPlayer: nextPlayer) {
            throw ResumeGameError.invalidNextPlayer
        }
    }
    
    private class func areNoFreeSpacesIn(board: Board) -> Bool {
        return board.numberOfSelectionsFor(.none) == 0
    }
    
    private class func isInvalidNextPlayer(board: Board, nextPlayer: PlayerSymbol) -> Bool {
        let crossCount = board.numberOfSelectionsFor(.cross)
        let circleCount = board.numberOfSelectionsFor(.circle)
        if crossCount > circleCount && nextPlayer == .cross {
            return true
        }
        if circleCount > crossCount && nextPlayer == .circle {
            return true
        }
        return false
    }
    
    private class func playerSelectedMoreSquaresThanAllowed(board: Board) -> Bool {
        let crossCount = board.numberOfSelectionsFor(.cross)
        let circleCount = board.numberOfSelectionsFor(.circle)
        return (abs(crossCount - circleCount) > 1)
    }
    
    func select(square: Int) -> Bool {
        if board.select(square: square, player: currentPlayer) {
            updateCurrentPlayer()
            didUpdateBoard?(board)
            checkIfWinnerIsFound()
            return true
        }
        return false
    }
    
    func newRound() {
        updatePlayerToStart()
        board.clean()
        didUpdateBoard?(board)
    }
    
    func restart(firstPlayerSymbol: PlayerSymbol) {
        playerToStart = firstPlayerSymbol
        currentPlayer = firstPlayerSymbol
        playerOne = Player(symbol: firstPlayerSymbol)
        playerTwo = Player(symbol: firstPlayerSymbol.getOppositeSymbol())
        board.clean()
        didUpdateBoard?(board)
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
        didFoundWinner?(winner)
        self.addPointTo(winner)
    }
    
    private func addPointTo(_ playerSymbol: PlayerSymbol) {
        if playerOne.symbol == playerSymbol {
            playerOne.score += 1
        } else {
            playerTwo.score += 1
        }
    }
    
    //MARK: - End game conditions
    private func checkIfWinnerIsFound() {
        if checkLines() { return }
        if checkColumns() { return }
        if checkDiagonals() { return }
        checkDraw()
    }
    
    private func checkDraw() {
        let freeSpaces = board.numberOfSelectionsFor(.none)
        if freeSpaces == 0 {
            didFoundWinner?(nil)
        }
    }

    private func checkDiagonals() -> Bool {
        if checkLeftDiagonal() {
            return true
        }
        if checkRightDiagonal() {
            return true
        }
        return false
    }
    
    private func checkRightDiagonal() -> Bool {
        let elementsToCheck = board.getSymbolsForPositions([2,4,6])
        if checkWinnerInArray(elementsToCheck) {
            return true
        }
        return false
    }
    
    private func checkLeftDiagonal() -> Bool {
        let elementsToCheck = board.getSymbolsForPositions([0,4,8])
        if checkWinnerInArray(elementsToCheck) {
            return true
        }
        return false
    }
    
    private func checkColumns() -> Bool {
        for i in 0...2 {
            let elementsToCheck = board.getSymbolsForPositions([i,i+3,i+6])
            if checkWinnerInArray(elementsToCheck) {
                return true
            }
        }
        return false
    }
    
    private func checkLines() -> Bool {
        for i in 0...2 {
            let elementsToCheck = board.getSymbolsForPositions([3*i,3*i+1,3*i+2])
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
        if areAllElementsEqualIn(array) {
            self.notifyClientWithWinner(array[0]!)
            return true
        }
        return false
    }
    
    private func areAllElementsEqualIn(_ array: [PlayerSymbol?]) -> Bool {
        return (array.filter { return $0 == array[0] }).count == array.count
    }
    
}
