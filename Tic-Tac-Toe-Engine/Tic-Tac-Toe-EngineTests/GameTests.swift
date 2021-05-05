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
    
    var gameClientSpy = GameClientSpy()
    var spyGame: Game {
        return gameClientSpy.game
    }
    
    func test_initNewGame_ShouldStartWithACleanBoard() {
        //given
        createCurrentGameSession(selectingOrder: [])

        //then
        let currentBoardState = spyGame.getBoardState()
        
        let expectedBoardState =  """
                                  . . .
                                  . . .
                                  . . .
                                  """
        
        XCTAssertEqual(currentBoardState, expectedBoardState)
    }
    
    
    func test_initNewGame_PlayersScoreShouldBeZero() {
        //given
        createCurrentGameSession(selectingOrder: [])
        
        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "0")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
    }

    
    func test_game_whenFirstPlayerSelectsAvailableSquare_squareStatusIsUpdated() {
        //given
        gameClientSpy.game = Game(delegate: gameClientSpy)
        spyGame.restart(firstPlayerSymbol: .cross)
        
        //when
        let isValidSelection = gameClientSpy.game.select(square: 4)
        
        //then
        let expectedBoardState =  """
                                  . . .
                                  . X .
                                  . . .
                                  """
        
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
        XCTAssertTrue(isValidSelection)
    }
    
    func testGame_whenOccupiedSquareIsSelected_squareStatusIsNotUpdated() {
        //given
        createCurrentGameSession(selectingOrder: [])
        
        //when
        _ = spyGame.select(square: 4)
        let secondSelectionResult = spyGame.select(square: 4)
        XCTAssertFalse(secondSelectionResult)
        
        //then
        let expectedBoardState =  """
                                  . . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
    }
    
    func test_game_whenPlayerChanges_shouldUpdateBoardWithPlayerSymbol() {
        //given
        createCurrentGameSession(selectingOrder: [4])
        
        //when
        _ = spyGame.select(square: 0)
        
        //then
        let expectedBoardState =  """
                                  O . .
                                  . X .
                                  . . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
    }
    
    func testGame_whenPlayerHasCompletedLine_clientShouldBeNotified(){
        //given
        createCurrentGameSession(selectingOrder: [0,3,1,4])
        
        //when
        _ = spyGame.select(square: 2)
        
        //then
        let expectedBoardState =  """
                                  X X X
                                  O O .
                                  . . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
        XCTAssertEqual(gameClientSpy.winner, .cross)
    }
    
    func testGame_whenPlayerHasCompletedColumn_clientShouldBeNotified(){
        //given
        createCurrentGameSession(selectingOrder: [0,1,3,4])
        
        //when
        _ = spyGame.select(square: 6)
        
        //then
        let expectedBoardState =  """
                                  X O .
                                  X O .
                                  X . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
        XCTAssertEqual(gameClientSpy.winner, .cross)
    }
    
    func testGame_whenPlayerHasCompletedLeftDiagonal_clientShouldBeNotified(){
        //given
        createCurrentGameSession(selectingOrder: [0,1,4,5])
        
        //when
        _ = spyGame.select(square: 8)
        
        //then
        let expectedBoardState =  """
                                  X O .
                                  . X O
                                  . . X
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
        XCTAssertEqual(gameClientSpy.winner, .cross)
    }
    
    func testGame_whenPlayerHasCompletedRightDiagonal_clientShouldBeNotified(){
        //given
        createCurrentGameSession(selectingOrder: [2,1,4,5])
        
        //when
        _ = spyGame.select(square: 6)
        
        //then
        let expectedBoardState =  """
                                  . O X
                                  . X O
                                  X . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
        XCTAssertEqual(gameClientSpy.winner, .cross)
    }
    
    func testGame_whenCircleWins_circleScoreShouldBeUpdated() {
        //given
        createCurrentGameSession(selectingOrder: [0,1,3,4], firstPlayerSymbol: .circle)
        XCTAssertEqual(spyGame.getPlayerOneScore(), "0")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
        
        //when
        _ = spyGame.select(square: 6)
        
        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "1")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
    }
    
    func testGame_whenCrossWins_circleScoreShouldBeUpdated() {
        //given
        createCurrentGameSession(selectingOrder: [2,1,4,5], firstPlayerSymbol: .cross)
        XCTAssertEqual(spyGame.getPlayerOneScore(), "0")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
        
        //when
        _ = spyGame.select(square: 6)
        
        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "1")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
    }
    
    func testGame_ifNewRound_shouldKeepCurrentScoreAndChangeFirstPlayerAndCleanBoard() {
        //given
        createCurrentGameSession(selectingOrder: [2,1,4,5], firstPlayerSymbol: .circle)
        _ = spyGame.select(square: 6)
        XCTAssertEqual(spyGame.getPlayerOneScore(), "1")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
        
        //when
        spyGame.newRound()
        
        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "1")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
        XCTAssertEqual(spyGame.getPlayerToStart(), "X")
        
        let expectedBoardState =  """
                                  . . .
                                  . . .
                                  . . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
    }
    
    func testGame_ifRestartGameWithInitialPlayer_shouldClearBoardAndScores() {
        //given
        createCurrentGameSession(selectingOrder: [2,1,4,5], firstPlayerSymbol: .circle)
        _ = spyGame.select(square: 6)
        XCTAssertEqual(spyGame.getPlayerOneScore(), "1")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
        
        //when
        spyGame.restart(firstPlayerSymbol: .cross)
        
        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "0")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
        XCTAssertEqual(spyGame.getPlayerToStart(), "X")
        
        let expectedBoardState =  """
                                  . . .
                                  . . .
                                  . . .
                                  """
        XCTAssertEqual(gameClientSpy.currentBoardState, expectedBoardState)
    }
    
    
    //MARK: - Helpers
    func createCurrentGameSession(selectingOrder: [Int], firstPlayerSymbol: PlayerSymbol = .cross){
        let game = Game(firstPlayerSymbol: firstPlayerSymbol, delegate: gameClientSpy)
        for selection in selectingOrder {
            _ = game.select(square: selection)
        }
        self.gameClientSpy.game = game
    }
}

class GameClientSpy: GameDelegate {
    var game: Game!
    var winner: PlayerSymbol? = nil
    var currentBoardState =   """
                              . . .
                              . . .
                              . . .
                              """
    
    func didUpdateBoard(_ board: String) {
        self.currentBoardState = board
    }
    
    func didFoundWinner(_ winner: PlayerSymbol) {
        self.winner = winner
    }
}
