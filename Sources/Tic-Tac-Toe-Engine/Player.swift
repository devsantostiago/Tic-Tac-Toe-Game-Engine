//
//  Player.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 06/05/2021.
//

import Foundation

public enum PlayerSymbol: String {
    case cross  = "X"
    case circle = "O"
    
    public func getOppositeSymbol() -> PlayerSymbol {
        if self == .cross {
            return .circle
        }
        return .cross
    }
}

public struct Player {
    var symbol: PlayerSymbol
    var score: Int = 0
    
    init(symbol: PlayerSymbol) {
        self.symbol = symbol
    }
}
