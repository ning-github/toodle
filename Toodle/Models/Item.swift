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
}
