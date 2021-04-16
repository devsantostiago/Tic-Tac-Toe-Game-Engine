//
//  Game.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation

enum Player {
    case one
    case two
}

class Game {
    func start(){
        
    }
    
    func freeSpaces() -> Int {
        return 9
    }
    
    func getPlayerScore(_ player: Player) -> Int {
        return 0
    }
}
