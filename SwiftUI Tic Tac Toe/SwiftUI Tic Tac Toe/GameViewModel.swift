//
//  GameViewModel.swift
//  SwiftUI Tic Tac Toe
//
//  Created by Muhammad Irtiza Khursheed on 08/05/2023.
//

import SwiftUI

final class GameViewModel : ObservableObject {
    
    var columns : [GridItem] = [ GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()) ]
    
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem : AlertItem?
    
    
    func processPlayerMove(in position: Int) {
        if(isSpaceAvailable(move: moves[position])) {
            moves[position] = Move(player: .human, boardIndex: position)
            
            if(checkWinCondition(for: .human, in: moves)) {
                
                alertItem = AlertContent.humanWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContent.draw
                return
            }
            
            isGameBoardDisabled = true
        } else {
            return
        }
        
        DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) { [self] in
            
            let computerPosition = determineCompoterMovePosition(in: moves)
            
                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
                isGameBoardDisabled = false
            
            if(checkWinCondition(for: .computer, in: moves)) {
                alertItem = AlertContent.computerWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContent.draw
                return
            }
            
        }
    }
    
    
    func resetGame() {
        moves  = Array(repeating: nil, count: 9)
    }
    
    func isSpaceAvailable(move : Move?) -> Bool {
        return move == nil
    }
    
    /*
     If AI can win, then win
     If AI can't win, then block
     If AI can't block, the take center position
     If AI can't take middle square, take randon available square
     */
    func determineCompoterMovePosition(in moves : [Move?]) -> Int {
        // If AI can win, then win
        
        let winPattern : Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [0,4,8], [1,4,7] , [2,5,8], [2,4,6]]
        
        let computerMoves = moves.compactMap {$0}.filter{$0.player == .computer}
        
        let computerMovesPositions  = computerMoves.map {$0.boardIndex}
        
        for pattern in winPattern {
            let winPositions = pattern.subtracting(computerMovesPositions)
            
            if winPositions.count == 1
            {
                let isAvailable = !isSpaceOccupiedForComputer(in: moves, index: winPositions.first!)
                
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        //  If AI can't win, then block
        
        let humanMoves = moves.compactMap {$0}.filter{$0.player == .human}
        
        let humanMovesPositions  = humanMoves.map {$0.boardIndex}
        
        for pattern in winPattern {
            let winPositions = pattern.subtracting(humanMovesPositions)
            
            if winPositions.count == 1
            {
                let isAvailable = !isSpaceOccupiedForComputer(in: moves, index: winPositions.first!)
                
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        
        // If AI can't block, the take center position
        let centerPosition = 4
        if !isSpaceOccupiedForComputer(in: moves, index: centerPosition) {
            return centerPosition
        }
        
        // If AI can't take middle square, take random available square
        var movePosition  = Int.random(in: 0..<9)
        
        while (isSpaceOccupiedForComputer(in : moves, index: movePosition)) {
            movePosition  = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func isSpaceOccupiedForComputer(in moves : [Move?], index : Int) -> Bool {
        
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func checkWinCondition(for player : Player , in moves : [Move?]) -> Bool {
        let winPattern : Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [0,4,8], [1,4,7] , [2,5,8], [2,4,6]]
        
        let playerMoves = moves.compactMap {$0}.filter{$0.player == player}
        
        let playerMovesPositions  = playerMoves.map {$0.boardIndex}
        
        for pattern in winPattern where pattern.isSubset(of: playerMovesPositions) { return true
        }
        
        return false
    }
    
    func checkForDraw(in moves : [Move?]) -> Bool {
        // compactMap removes all the null values
        return moves.compactMap {$0}.count == 9
    }
}
