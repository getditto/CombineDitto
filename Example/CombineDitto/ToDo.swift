//
//  ToDo.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 6/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import DittoSwift

struct ToDo: Hashable, Identifiable {
    var id: String
    var body: String
    var isCompleted: Bool

    init(document: DittoDocument) {
        self.id = document.id.toString()
        self.body = document["body"].stringValue
        self.isCompleted = document["isCompleted"].boolValue
    }
}
