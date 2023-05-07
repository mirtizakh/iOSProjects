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
                                
                                isGameBoardDisabled = true
                                
                                if(checkWinCondition(for: .human, in: moves)) {
                                    
                                }
                            } else {
                                return
                            }
                            
                            DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) {
                                
                                let computerPosition = determineCompoterMovePosition(in: moves)
                                
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                
                                isGameBoardDisabled = false
                                
                                if(checkWinCondition(for: .computer, in: moves)) {
                                    
                                }
                                
                            }
                                
                            
                            
                        }
                    }
                }
              Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
        }
        
    }
    
    func isSpaceAvailable(move : Move?) -> Bool {
        return move == nil
    }
    
    func determineCompoterMovePosition(in moves : [Move?]) -> Int {
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
