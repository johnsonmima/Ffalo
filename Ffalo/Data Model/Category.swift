//
//  Category.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 12/9/20.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var dateCreated:Date = Date()
    @objc dynamic var color:String = ""
    let items = List<Item>()
}
