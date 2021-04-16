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
    
    func test_initNewGame_ShouldStartWithACleanBoard() {
        //Given
        let game = Game()
        
        //When
        let currentBoardState = game.getBoardState()
        
        //Then
        let expectedBoardState =  """
                                  . . .
                                  . . .
                                  . . .
                                  """
        
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    
    func test_initNewGame_PlayersScoreShouldBeZero() {
        //Given
        let game = Game()
        
        //Then
        XCTAssertEqual(game.playerOneScore, 0)
        XCTAssertEqual(game.playerTwoScore, 0)
    }

    
    func testGame_whenCrossSelectsSquare_scoreStatusIsUpdated() {
        //Given
        let game = Game()
        
        //When
        game.select(square: 4)
        
        //Then
        let currentBoardState = game.getBoardState()
        let expectedBoardState =  """
                                  . . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }

}
