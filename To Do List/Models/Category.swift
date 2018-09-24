//
//  Category.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-23.
//  Copyright © 2018 Sultani. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>() // One to many relationship with Item
}
