//
//  GalleryImage.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 9/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import DittoSwift

struct Picture {

    var _id: String
    var name: String
    var mimeType: String
    var image: DittoAttachmentToken?

    init(document: DittoDocument) {
        _id = document["_id"].stringValue
        name = document["name"].stringValue
        mimeType = document["mimeType"].stringValue
        image = document["image"].attachmentToken
    }
}

extension Picture: Identifiable {
    var id: String { return _id }
    
}
