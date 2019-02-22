//
//  Category.swift
//  Toodle
//
//  Created by NingX on 2/1/19.
//  Copyright © 2019 ningco. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var createdAt: Date?
    
    // define forward relationship
    let items = List<Item>()
}
