//
//  taskModel.swift
//  toDo
//
//  Created by Ece Ok, Vodafone on 17.04.2024.
//

import Foundation


struct Task : Decodable {
    let textInfo : String!
    var status : String = "To Do"
    let key : String?
    
    init(textInfo: String!, status: String , key: String? = nil) {
        self.textInfo = textInfo
        self.status = status
        self.key = key
    }
}
