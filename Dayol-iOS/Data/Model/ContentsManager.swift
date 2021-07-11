//
//  ContentsManager.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/09.
//

import Foundation

class ContentsManager {
    static let shared = ContentsManager()

    func addContents(to diaryMO: DiaryMO, items: [DecorationItem]) {
        items.forEach {
            // TODO: - 상속 구조로 다듬을 수 없는지?

            if let textFieldItem = $0 as? DecorationTextFieldItem {
                // DecorationTextFieldItem
                let managedObject = PersistentManager.shared.insertObject(.decorationTextFieldItem)

                guard let textFieldItemMO = managedObject as? DecorationTextFieldItemMO else { return}

                textFieldItemMO.make(item: textFieldItem)
                diaryMO.addToContents(textFieldItemMO)
            } else if let imageItem = $0 as? DecorationImageItem {
                // DecorationImageItem
            } else if let sticker = $0 as? DecorationStickerItem {
                // DecorationStickerItem
            }
        }
    }
}
