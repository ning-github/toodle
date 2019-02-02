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
    
    // define forward relationship
    let items = List<Item>()
}
