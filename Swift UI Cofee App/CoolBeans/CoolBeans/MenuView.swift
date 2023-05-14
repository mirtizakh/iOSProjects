//
//  MenuView.swift
//  CoolBeans
//
//  Created by Muhammad Irtiza Khursheed on 14/05/2023.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var menu : Menu
    
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(menu.sections) { section in
                        Section {
                            ForEach(section.drinks) {drink in
                                VStack{
                                    Text(drink.name)
                                }.padding(.bottom)
                            }
                        }
                    }
                }.padding(.horizontal)
            }.navigationTitle("Add Drink")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(Menu())
    }
}
