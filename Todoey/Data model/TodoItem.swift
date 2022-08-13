//
//  TodoItem.swift
//  Todoey
//
//  Created by Bekzod Qahhorov on 13/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class TodoItem: Encodable, Decodable {
    var title: String = ""
    var IsDone: Bool = false
}
