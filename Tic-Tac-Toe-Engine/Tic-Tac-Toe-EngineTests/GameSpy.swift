//
//  GameSpy.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 06/05/2021.
//

import Foundation
@testable import Tic_Tac_Toe_Engine

class GameClientSpy {
    
    var game: Game!
    var winner: PlayerSymbol? = nil
    var currentBoardState =   """
                              . . .
                              . . .
                              . . .
                              """
    
    func didUpdateBoard(_ board: Board) {
        self.currentBoardState = convertBoardIntoString(board)
    }
    
    func didFoundWinner(_ winner: PlayerSymbol?) {
        self.winner = winner
    }
    
    func setCurrentBoardStateWith(board: [PlayerSymbol?] = [PlayerSymbol?](repeating: nil, count: 9), nextPlayer: PlayerSymbol = .circle) {
        self.game = try? Game(board: board, nextPlayer: nextPlayer)
        self.game.didFoundWinner = didFoundWinner
        self.game.didUpdateBoard = didUpdateBoard
    }

    //MARK: - Helper functions
    
    func convertBoardIntoString(_ board: Board) -> String {
        var boardString = ""
        for i in 0..<9 {
            if isEndOfLine(i: i) {
                boardString.append("\n")
            }
            boardString.append(getSymbolForPosition(i: i, board: board))
            if isNotEndOfLine(i) {
                boardString.append(" ")
            }
        }
        return boardString
    }
        
    private func isNotEndOfLine(_ i: Int) -> Bool {
        return i != 2 && i != 5 && i != 8
    }
    
    private func getSymbolForPosition(i: Int, board: Board) -> String {
        guard let boardPosition = board.getSymbolForPosition(index: i) else {
            return "."
        }
        return boardPosition.rawValue
    }
    
    private func isEndOfLine(i: Int) -> Bool {
        return i == 3 || i == 6
    }
}
