//
//  ContentView.swift
//  CoolBeans
//
//  Created by Muhammad Irtiza Khursheed on 14/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var menu = Menu()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
