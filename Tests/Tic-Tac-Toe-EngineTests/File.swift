//
//  Helpers.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 13/05/2021.
//

@testable import Tic_Tac_Toe_Engine

class Helpers {
    
    static func convertStringIntoBoard(_ string: String) -> [PlayerSymbol?] {
        var currentBoard = [PlayerSymbol?]()
        let stringArray = Array(string)
        stringArray.forEach {
            switch $0 {
            case ".":
                 currentBoard.append(.none)
            case "X":
                 currentBoard.append(.cross)
            case "O":
                currentBoard.append(.circle)
            default:
                print("")
            }
        }
        return currentBoard
    }
    
}
