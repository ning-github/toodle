//
//  Item.swift
//  Toodle
//
//  Created by NingX on 2/1/19.
//  Copyright © 2019 ningco. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdAt: Date?
    
    // define inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
