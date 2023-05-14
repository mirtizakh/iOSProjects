//
//  Drink.swift
//  CoolBeans
//
//  Created by Muhammad Irtiza Khursheed on 14/05/2023.
//

import Foundation

//Identifiable -> We used it to make unique Id
//Codable -> To convert data from json

struct Drink : Identifiable , Codable {
    let id : UUID
    let name : String
}
