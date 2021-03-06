//
//  GameTests.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 16/04/2021.
//

import XCTest

@testable import Tic_Tac_Toe_Engine

class GameTests: XCTestCase {
    
    var gameClientSpy = GameClientSpy()
    var spyGame: Game {
        return gameClientSpy.game
    }
    
    //MARK: - New clean game tests
    
    func test_initNewGame_ShouldStartWithACleanBoard() {
        //given
        gameClientSpy.setCurrentBoardStateWith()

        //then
        let currentBoardState = gameClientSpy.currentBoardState

        let expectedBoardState =  """
                                  . . .
                                  . . .
                                  . . .
                                  """

        XCTAssertEqual(currentBoardState, expectedBoardState)
    }


    func test_initNewGame_PlayersScoreShouldBeZero() {
        //given
        gameClientSpy.setCurrentBoardStateWith()

        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "0")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
    }
    
    //MARK: - Winning conditions tests
    
    func testGame_detectsCrossAsWinner() {
        GameTestsCases.boardNextSelectionAndCrossWinner.forEach {
            verifyGameInputPair(pair: $0, nextPlayer: .cross)
        }
    }
    
    func testGame_detectsCircleAsWinner() {
        GameTestsCases.boardNextSelectionAndCircleWinner.forEach {
            verifyGameInputPair(pair: $0, nextPlayer: .circle)
        }
    }
    
    func testGame_canDetectDraw() {
        GameTestsCases.boardNextSelectionAndDraw.forEach {
            //given
            gameClientSpy.setCurrentBoardStateWith(board: Helpers.convertStringIntoBoard($0.0), nextPlayer: .cross)
            
            //when
            _ = spyGame.select(square: $0.1)
            
            //then
            XCTAssertEqual(gameClientSpy.winner, nil)
        }
    }
    
    //MARK: - Selection and score logic tests
    
    func testGame_whenOccupiedSquareIsSelected_squareStatusIsNotUpdated() {
        //given
        gameClientSpy.setCurrentBoardStateWith(nextPlayer: .cross)
        
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
    
    func testGame_whenCircleWins_circleScoreShouldBeUpdated() {
        //given
        let initialBoard =    """
                              O X .
                              O X .
                              . . .
                              """
        gameClientSpy.setCurrentBoardStateWith(board: Helpers.convertStringIntoBoard(initialBoard), nextPlayer: .circle)
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
        let initialBoard = """
                          X O .
                          X O .
                          . . .
                          """
        gameClientSpy.setCurrentBoardStateWith(board: Helpers.convertStringIntoBoard(initialBoard), nextPlayer: .cross)
        XCTAssertEqual(spyGame.getPlayerOneScore(), "0")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")

        //when
        _ = spyGame.select(square: 6)

        //then
        XCTAssertEqual(spyGame.getPlayerOneScore(), "1")
        XCTAssertEqual(spyGame.getPlayerTwoScore(), "0")
    }

    //MARK: - New round and restart logic tests
    
    func testGame_ifNewRound_shouldKeepCurrentScoreAndChangeFirstPlayerAndCleanBoard() {
        //given
        let initialBoard =    """
                              . X O
                              . O X
                              . . .
                              """
        gameClientSpy.setCurrentBoardStateWith(board: Helpers.convertStringIntoBoard(initialBoard), nextPlayer: .circle)
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
    
    func testGame_whenRestartGame_shouldClearBoardAndScores() {
        //given
        let initialBoard =    """
                              . X O
                              . O X
                              . . .
                              """
        gameClientSpy.setCurrentBoardStateWith(board: Helpers.convertStringIntoBoard(initialBoard), nextPlayer: .circle)
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
    
    //MARK: - Resume game with invalid state error tests
    
    func testGame_detectsInvalidBoard() {
        GameTestsCases.invalidBoards.forEach {
            let board = Helpers.convertStringIntoBoard($0.0)
            validateThrowErrorWhen(board: board, expectedErrorType: $0.1)
        }
    }
    
    private func validateThrowErrorWhen(board: [PlayerSymbol?], expectedErrorType: ResumeGameError) {
        do {
            _ = try Game(board: board, nextPlayer: .cross)
            XCTFail("Should throw error of type \(expectedErrorType)")
        }catch let error as ResumeGameError{
            XCTAssertEqual(error, expectedErrorType)
        }catch{
            XCTFail("Should throw error of type \(expectedErrorType)")
        }
    }
    
    func testGame_detectsInvalidNextPlayer() {
        GameTestsCases.invalidNextPlayer.forEach {
            let board = Helpers.convertStringIntoBoard($0.0)
            validateThrowsNextPlayerError(board: board, nextPlayer: $0.1)
        }
    }
    
    private func validateThrowsNextPlayerError(board: [PlayerSymbol?], nextPlayer: PlayerSymbol) {
        do {
            _ = try Game(board: board, nextPlayer: nextPlayer)
            XCTFail("Should throw error of type ResumeGameError.invalidNextPlayer")
        }catch let error as ResumeGameError{
            XCTAssertEqual(error, ResumeGameError.invalidNextPlayer)
        }catch{
            XCTFail("Should throw error of type ResumeGameError.invalidNextPlayer")
        }
    }
    
    //MARK: - Helpers
    
    func verifyGameInputPair(pair: (String, Int), nextPlayer: PlayerSymbol) {
        //given
        gameClientSpy.setCurrentBoardStateWith(board: Helpers.convertStringIntoBoard(pair.0), nextPlayer: nextPlayer)
        
        //when
        _ = spyGame.select(square: pair.1)
        
        //then
        XCTAssertEqual(gameClientSpy.winner, nextPlayer)
    }
}
