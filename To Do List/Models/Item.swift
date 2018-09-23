//
//  Item.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-22.
//  Copyright © 2018 Sultani. All rights reserved.
//

import Foundation

// Inherited NSObject and NSCoding required for saving to user defaults
class Item: NSObject, NSCoding {
    var title: String = ""
    var checked: Bool = false
    
    init(t: String, c: Bool) {
        title = t
        checked = c
    }
    
    // The code below is required to be able to save an array with custom object
    // i.e. [Item] instead of [String]
    // We have to encode our Item object to a Data object so that it can be saved to UserDefaults
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let checked = aDecoder.decodeBool(forKey: "checked") as! Bool
        self.init(t: title, c: checked)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(checked, forKey: "checked")
    }
}
