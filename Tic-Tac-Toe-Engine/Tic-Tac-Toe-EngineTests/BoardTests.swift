//
//  BoardTests.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 13/05/2021.
//

import Foundation
import XCTest

@testable import Tic_Tac_Toe_Engine

class BoardTests: XCTestCase {
    
    func testBoard_cleanInit_shouldHaveNineFreeSpaces() {
        let board = Board()
        XCTAssertEqual(board.numberOfSelectionsFor(.none), 9)
    }
        
    func testBoard_initWithInvalidBoard_shouldThrowError() {
        GameTestsCases.invalidSizeBoards.forEach {
            do {
                _ = try Board(board: Helpers.convertStringIntoBoard($0.0))
                XCTFail("Should throw error of type \($0.1) \n in board \($0.0)")
            }catch let error as ResumeGameError{
                XCTAssertEqual(error, $0.1)
            }catch{
                XCTFail("Should throw error of type \($0.1)")
            }
        }
    }
}
