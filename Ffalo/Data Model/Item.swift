//
//  Item.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 12/9/20.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date = Date()
    
    let parentCategory = LinkingObjects(fromType:Category.self, property:"items")
}
