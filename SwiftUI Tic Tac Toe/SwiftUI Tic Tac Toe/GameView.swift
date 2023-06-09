//
//  GameView.swift
//  SwiftUI Tic Tac Toe
//
//  Created by Muhammad Irtiza Khursheed on 07/05/2023.
//

import SwiftUI


struct GameView: View {
    
    // state object is used for classes introduced in swift 14
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack{
              Spacer()
                LazyVGrid (columns: viewModel.columns, spacing: 10){
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,height: geometry.size.width/3 - 15)
                            
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40,height: 40)
                                .foregroundColor(.white)
                        }.onTapGesture {
                            
                            viewModel.processPlayerMove(in: i)
                        }
                    }
                }
              Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item : $viewModel.alertItem , content: {
                alertItem in
                Alert(title: alertItem.title,message: alertItem.message, dismissButton: .default(alertItem.buttonText, action: {viewModel.resetGame()} ))
            } )
        }
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
