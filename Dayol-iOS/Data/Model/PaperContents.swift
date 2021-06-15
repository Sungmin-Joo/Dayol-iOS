//
//  PaperContents.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import Foundation

protocol DecorationItem: Codable {
    var id: String { get } // C1, C2
    var parentId: String { get } // Dx or Px

    var width: Float { get }
    var height: Float { get }
    var x: Float { get }
    var y: Float { get }
}

struct DecorationImageItem: DecorationItem {
    let id: String
    let parentId: String

    let width: Float
    let height: Float
    let x: Float
    let y: Float

    let image: Data
    let inclination: Float
}

struct DecorationStickerItem: DecorationItem {
    let id: String
    let parentId: String

    let width: Float
    let height: Float
    let x: Float
    let y: Float

    let image: Data
    let inclination: Float
}

struct DecorationTextFieldItem: DecorationItem {
    let id: String
    let parentId: String

    let width: Float
    let height: Float
    let x: Float
    let y: Float

    let textData: Data
}
