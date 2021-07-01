//
//  PaperContents.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import Foundation


class DecorationItem {
    let id: String
    let parentId: String

    let width: Float
    let height: Float
    let x: Float
    let y: Float

    init(id: String, parentId: String, width: Float, height: Float, x: Float, y: Float) {
        self.id = id
        self.parentId = parentId
        self.width = width
        self.height = height
        self.x = x
        self.y = y
    }
}

class DecorationImageItem: DecorationItem {
    let image: Data
    let inclination: Float

    init(id: String, parentId: String, width: Float, height: Float, x: Float, y: Float, image: Data, inclination: Float) {
        self.image = image
        self.inclination = inclination
        super.init(id: id, parentId: parentId, width: width, height: height, x: x, y: y)
    }
}

class DecorationStickerItem: DecorationItem {
    let image: Data
    let inclination: Float

    init(id: String, parentId: String, width: Float, height: Float, x: Float, y: Float, image: Data, inclination: Float) {
        self.image = image
        self.inclination = inclination
        super.init(id: id, parentId: parentId, width: width, height: height, x: x, y: y)
    }
}

class DecorationTextFieldItem: DecorationItem {
    let textData: Data

    init(id: String, parentId: String, width: Float, height: Float, x: Float, y: Float, textData: Data) {
        self.textData = textData
        super.init(id: id, parentId: parentId, width: width, height: height, x: x, y: y)
    }
}
