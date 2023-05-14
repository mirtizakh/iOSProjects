//
//  MenuSection.swift
//  CoolBeans
//
//  Created by Muhammad Irtiza Khursheed on 14/05/2023.
//

import Foundation


struct MenuSection : Identifiable, Codable {
    let id : UUID
    let name : String
    let drinks : [Drink]
}
