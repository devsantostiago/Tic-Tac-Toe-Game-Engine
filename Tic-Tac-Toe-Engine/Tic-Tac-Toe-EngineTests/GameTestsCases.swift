//
//  GameTestCases.swift
//  Tic-Tac-Toe-EngineTests
//
//  Created by Tiago Santos on 05/05/2021.
//

import Foundation

class GameTestsCases {
    
    static let boardNextSelectionAndCrossWinner:[(String, Int)] = [
        ( """
          X X .
          O O .
          . . .
          """, 2),
        ( """
          O O .
          X X .
          . . .
          """, 5),
        ( """
          . . .
          O O .
          X X .
          """, 8),
        ( """
          X O .
          X O .
          . . .
          """, 6),
        ( """
          . X O
          . X O
          . . .
          """, 7),
        ( """
          . O X
          . O X
          . . .
          """, 8),
        ( """
          X O .
          . X O
          . . .
          """, 8),
        ( """
          . O X
          . X O
          . . .
          """, 6)
    ]
    
    static let boardNextSelectionAndCircleWinner:[(String, Int)] = [
        ( """
          O O .
          X X .
          . . .
          """, 2),
        ( """
          X X .
          O O .
          . . .
          """, 5),
        ( """
          . . .
          X X .
          O O .
          """, 8),
        ( """
          O X .
          O X .
          . . .
          """, 6),
        ( """
          . O X
          . O X
          . . .
          """, 7),
        ( """
          . X O
          . X O
          . . .
          """, 8),
        ( """
          O X .
          . O X
          . . .
          """, 8),
        ( """
          . X O
          . O X
          . . .
          """, 6)
    ]
    
    static let boardNextSelectionAndDraw:[(String, Int)] = [
        ( """
          O O X
          X X O
          O X .
          """, 8),
        (  """
          X X O
          O O X
          . O X
          """, 6)
    ]
    
    static let invalidBoards:[String] = [
        """
        O O O
        O X X
        . . X
        """,
        
        """
        X X .
        O . .
        . . .
        """,
        
        """
        O O O
        X X .
        O O .
        """,
        
        """
        O O O
        O X .
        . . .
        """,
        
        """
        O O .
        . . .
        . . .
        """
    ]
    
}
