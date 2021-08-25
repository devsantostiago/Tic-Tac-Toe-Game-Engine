//
//  Board.swift
//  Tic-Tac-Toe-Engine
//
//  Created by Tiago Santos on 07/05/2021.
//

public struct Board {
    
    private var squares = [PlayerSymbol?]()
    
    public init() {
        clean()
    }
    
    public init(board: [PlayerSymbol?]) throws {
        if isInvalidBoardSize(board: board) {
            throw ResumeGameError.invalidBoardSize
        }
        self.squares = board
    }
    
    mutating func clean() {
        squares = [PlayerSymbol?](repeating: nil, count: 9)
    }
    
    func numberOfSelectionsFor(_ player: PlayerSymbol?) -> Int {
        return (squares.filter { return $0 == player }).count
    }
    
    func isInvalidBoardSize(board: [PlayerSymbol?]) -> Bool {
        return board.count != 9
    }
    
    public mutating func select(square: Int, player: PlayerSymbol) -> Bool {
        if squares[square] != .none {
            return false
        }
        squares[square] = player
        return true
    }
    
    func getSymbolsForPositions(_ indexes: [Int]) -> [PlayerSymbol?] {
        var boardSquares = [PlayerSymbol?]()
        for index in indexes {
            boardSquares.append(squares[index])
        }
        return boardSquares
    }
    
    func getSymbolForPosition(index: Int) -> PlayerSymbol?{
        return squares[index]
    }
    
    public func getFreeSquares() -> [Int] {
        var freeSquares = [Int]()
        for i in 0..<squares.count{
            if squares[i] == .none {
                freeSquares.append(i)
            }
        }
        return freeSquares
    }
}
