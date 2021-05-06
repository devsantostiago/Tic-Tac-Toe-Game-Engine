//
//  GameSpy.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 06/05/2021.
//

import Foundation
@testable import Tic_Tac_Toe_Engine

class GameClientSpy: GameDelegate {
    
    var game: Game!
    var winner: PlayerSymbol? = nil
    var currentBoardState =   """
                              . . .
                              . . .
                              . . .
                              """
    
    func didUpdateBoard(_ board: [PlayerSymbol?]) {
        self.currentBoardState = convertBoardIntoString(board)
    }
    
    func didFoundWinner(_ winner: PlayerSymbol?) {
        self.winner = winner
    }
    
    func setCurrentBoardStateWith(board: [PlayerSymbol?] = [PlayerSymbol?](repeating: nil, count: 9), nextPlayer: PlayerSymbol = .circle) {
        self.game = Game(board: board, delegate: self, nextPlayer: nextPlayer)
    }

    //MARK: - Helper functions
    func convertBoardIntoString(_ board: [PlayerSymbol?]) -> String {
        var boardString = ""
        for i in 0..<board.count {
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
    
    private func getSymbolForPosition(i: Int, board: [PlayerSymbol?]) -> String {
        guard let boardPosition = board[i] else {
            return "."
        }
        return boardPosition.rawValue
    }
    
    private func isEndOfLine(i: Int) -> Bool {
        return i == 3 || i == 6
    }
}
