//
//  GameTests.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 16/04/2021.
//

import Foundation
import XCTest

@testable import Tic_Tac_Toe_Engine

class GameTests: XCTestCase {
    
    func test_initNewGame_ShouldStartWithACleanBoard(){
        //Given
        let game = Game()
        
        //When
        game.start()
        
        //Then
        XCTAssertEqual(game.freeSpaces(), 9)
    }
    
    func test_initNewGame_PlayersScoreShouldBeZero(){
        //Given
        let game = Game()
        
        //When
        game.start()
        
        //Then
        XCTAssertEqual(game.getPlayerScore(Player.one), 0)
        XCTAssertEqual(game.getPlayerScore(Player.two), 0)
    }

}
