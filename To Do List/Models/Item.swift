//
//  Item.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-23.
//  Copyright © 2018 Sultani. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // One to one relationship with Category
    
}
