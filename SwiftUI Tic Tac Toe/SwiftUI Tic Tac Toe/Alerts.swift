//
//  Alerts.swift
//  SwiftUI Tic Tac Toe
//
//  Created by Muhammad Irtiza Khursheed on 08/05/2023.
//

import SwiftUI

struct AlertItem : Identifiable {
    
    let id = UUID()
    var title : Text
    var message : Text
    var buttonText : Text
}

struct AlertContent {
    static let humanWin = AlertItem(title: Text("Congrats"), message: Text("Congrats , you win the game"), buttonText: Text("Continue"))
    
    static let computerWin = AlertItem(title: Text("Sorry"), message: Text("You lost the game"), buttonText: Text("Continue"))
    
    static let draw = AlertItem(title: Text("Draw"), message: Text("Game is draw"), buttonText: Text("Reset game"))
}
