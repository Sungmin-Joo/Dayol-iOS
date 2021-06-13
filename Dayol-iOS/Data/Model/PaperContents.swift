//
//  PaperContents.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/12.
//

import Foundation

class DecorationItem: Codable {
    let id: String // C1, C2
    let parentId: String // Dx or Px

    let width: Float
    let height: Float
    let x: Float
    let y: Float
    let inclination: Float
}

final class DecorationImageItem: DecorationItem {}

final class DecorationStickerItem: DecorationItem {}

final class DecorationTextFieldItem: DecorationItem {}
