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
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [])

        //THEN
        let currentBoardState = game.getBoardState()
        
        let expectedBoardState =  """
                                  . . .
                                  . . .
                                  . . .
                                  """
        
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    
    func test_initNewGame_PlayersScoreShouldBeZero() {
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [])
        
        //THEN
        XCTAssertEqual(game.getPlayerOneScore(), "0")
        XCTAssertEqual(game.getPlayerTwoScore(), "0")
    }

    
    func testGame_whenCrossSelectsAvailableSquare_squareStatusIsUpdated() {
        //GIVEN
        let game = Game()
        
        //WHEN
        let isValidSelection = game.select(square: 4)
        
        //THEN
        let currentBoardState = game.getBoardState()
        let expectedBoardState =  """
                                  . . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
        XCTAssertTrue(isValidSelection)
    }
    
    func testGame_whenOccupiedSquareIsSelected_squareStatusIsNotUpdated() {
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [4])
        
        //WHEN
        let secondSelectionResult = game.select(square: 4)
        XCTAssertFalse(secondSelectionResult)
        
        //THEN
        let currentBoardState = game.getBoardState()
        let expectedBoardState =  """
                                  . . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    func testGame_whenPlayerChanges_shouldUpdateBoardWithPlayerSymbol() {
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [4])
        
        //WHEN
        _ = game.select(square: 0)
        
        //THEN
        let currentBoardState = game.getBoardState()
        let expectedBoardState =  """
                                  O . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    func testGame_whenPlayerHasCompletedLine_didFondWinnerShouldBeCalled(){
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [0,3,1,4])
        var isWinnerFound = false
        game.didFoundWinner = { winner in
            isWinnerFound = true
        }
        
        //WHEN
        _ = game.select(square: 2)
        
        //THEN
        let currentBoardState = game.getBoardState()
        let expectedBoardState =  """
                                  X X X
                                  O O .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
        XCTAssertTrue(isWinnerFound)
    }

    //MARK: - Helpers
    func createCurrentGameSession(selectingOrder: [Int]) -> Game{
        let game = Game()
        for selection in selectingOrder {
            _ = game.select(square: selection)
        }
        return game
    }
    

}
