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
    
    var foundWinner = false
    var currentBoardState =   """
                              . . .
                              . . .
                              . . .
                              """
    
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

    
    func test_game_whenFirstPlayerSelectsAvailableSquare_squareStatusIsUpdated() {
        //GIVEN
        let game = Game(firstPlayerSymbol: .cross)
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        let isValidSelection = game.select(square: 4)
        
        //THEN
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
        let game = createCurrentGameSession(selectingOrder: [])
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        _ = game.select(square: 4)
        let secondSelectionResult = game.select(square: 4)
        XCTAssertFalse(secondSelectionResult)
        
        //THEN
        let expectedBoardState =  """
                                  . . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    func test_game_whenPlayerChanges_shouldUpdateBoardWithPlayerSymbol() {
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [4])
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        _ = game.select(square: 0)
        
        //THEN
        let expectedBoardState =  """
                                  O . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    func testGame_whenPlayerHasCompletedLine_clientShouldBeNotified(){
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [0,3,1,4])
        game.didFoundWinner = { winner in
            self.foundWinner = true
        }
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        _ = game.select(square: 2)
        
        //THEN
        let expectedBoardState =  """
                                  X X X
                                  O O .
                                  . . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
        XCTAssertTrue(foundWinner)
    }
    
    func testGame_whenPlayerHasCompletedColumn_clientShouldBeNotified(){
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [0,1,3,4])
        game.didFoundWinner = { winner in
            self.foundWinner = true
        }
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        _ = game.select(square: 6)
        
        //THEN
        let expectedBoardState =  """
                                  X O .
                                  X O .
                                  X . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
        XCTAssertTrue(foundWinner)
    }
    
    func testGame_whenPlayerHasCompletedLeftDiagonal_clientShouldBeNotified(){
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [0,1,4,5])
        game.didFoundWinner = { winner in
            self.foundWinner = true
        }
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        _ = game.select(square: 8)
        
        //THEN
        let expectedBoardState =  """
                                  X O .
                                  . X O
                                  . . X
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
        XCTAssertTrue(foundWinner)
    }
    
    func testGame_whenPlayerHasCompletedRightDiagonal_clientShouldBeNotified(){
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [2,1,4,5])
        game.didFoundWinner = { winner in
            self.foundWinner = true
        }
        game.didUpdateBoard = { board in
            self.currentBoardState = board
        }
        
        //WHEN
        _ = game.select(square: 6)
        
        //THEN
        let expectedBoardState =  """
                                  . O X
                                  . X O
                                  X . .
                                  """
        XCTAssertEqual(currentBoardState, expectedBoardState)
        XCTAssertTrue(foundWinner)
    }
    
    func testGame_whenCircleWins_circleScoreShouldBeUpdated() {
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [0,1,3,4], firstPlayerSymbol: .circle)
        XCTAssertEqual(game.getPlayerOneScore(), "0")
        XCTAssertEqual(game.getPlayerTwoScore(), "0")
        
        //WHEN
        _ = game.select(square: 6)
        
        //THEN
        XCTAssertEqual(game.getPlayerOneScore(), "1")
        XCTAssertEqual(game.getPlayerTwoScore(), "0")
    }
    
    func testGame_whenCrossWins_circleScoreShouldBeUpdated() {
        //GIVEN
        let game = createCurrentGameSession(selectingOrder: [2,1,4,5], firstPlayerSymbol: .cross)
        XCTAssertEqual(game.getPlayerOneScore(), "0")
        XCTAssertEqual(game.getPlayerTwoScore(), "0")
        
        //WHEN
        _ = game.select(square: 6)
        
        //THEN
        XCTAssertEqual(game.getPlayerOneScore(), "1")
        XCTAssertEqual(game.getPlayerTwoScore(), "0")
    }
    
    //MARK: - Helpers
    func createCurrentGameSession(selectingOrder: [Int], firstPlayerSymbol: PlayerSymbol = .cross) -> Game{
        let game = Game(firstPlayerSymbol: firstPlayerSymbol)
        for selection in selectingOrder {
            _ = game.select(square: selection)
        }
        return game
    }
    

}
