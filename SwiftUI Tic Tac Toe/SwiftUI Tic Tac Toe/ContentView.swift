//
//  ContentView.swift
//  SwiftUI Tic Tac Toe
//
//  Created by Muhammad Irtiza Khursheed on 07/05/2023.
//

import SwiftUI


struct ContentView: View {
    
    var columns : [GridItem] = [ GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()) ]
    
    
    @State private var moves : [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem : AlertItem?
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack{
              Spacer()
                LazyVGrid (columns: columns, spacing: 10){
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,height: geometry.size.width/3 - 15)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40,height: 40)
                                .foregroundColor(.white)
                        }.onTapGesture {
                            
                            if(isSpaceAvailable(move: moves[i])) {
                                moves[i] = Move(player: .human, boardIndex: i)
                                
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
                            
                            DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) {
                                
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
                    }
                }
              Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(item : $alertItem , content: {
                alertItem in
                Alert(title: alertItem.title,message: alertItem.message, dismissButton: .default(alertItem.buttonText, action: {resetGame()} ))
            } )
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
        
        // If AI can't take middle square, take randon available square
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

enum Player {
    case human , computer
}

struct Move {
    let player : Player
    let boardIndex : Int
    
    var indicator : String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
