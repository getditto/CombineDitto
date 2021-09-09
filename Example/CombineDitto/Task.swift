//
//  ToDo.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 6/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import DittoSwift

struct Task {
    var _id: String
    var body: String
    var isCompleted: Bool

    init(document: DittoDocument) {
        self._id = document["_id"].stringValue
        self.body = document["body"].stringValue
        self.isCompleted = document["isCompleted"].boolValue
    }
}

extension Task: Identifiable {
    var id: String { return _id }
}
