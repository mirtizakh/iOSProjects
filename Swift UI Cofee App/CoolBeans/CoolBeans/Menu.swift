//
//  Menu.swift
//  CoolBeans
//
//  Created by Muhammad Irtiza Khursheed on 14/05/2023.
//

import Foundation

class Menu : ObservableObject , Codable {
    let menuSections : [MenuSection]
    
    init(){
        do{
            
            let url = Bundle.main.url(forResource: "menu", withExtension: "json")! // making it force unwrap , I know the file is available
            
            // loading the contents of the file
            let data = try Data(contentsOf: url)
            
            // Now to decode that into a menu
            let menuData = try JSONDecoder.decode(Menu.self,from: data)
            
            sections = menuData.menuSections
        } catch {
            fatalError("menu.json is missing or corrupt.")
        }
    }
}
