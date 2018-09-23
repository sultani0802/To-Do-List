//
//  Item.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-22.
//  Copyright © 2018 Sultani. All rights reserved.
//

import Foundation

// Codable = Encodable, Decodable
class Item: Codable {
    var title: String = ""
    var checked: Bool = false
    
    init(t: String, c: Bool) {
        title = t
        checked = c
    }
}
