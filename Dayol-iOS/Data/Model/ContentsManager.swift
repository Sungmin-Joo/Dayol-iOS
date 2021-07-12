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
        items.forEach { item in
            // TODO: - 상속 구조로 다듬을 수 없는지?

            var managedObject: DecorationItemMO?

            switch item {
            case is DecorationTextFieldItem:
                managedObject = PersistentManager.shared.insertObject(.decorationTextFieldItem) as? DecorationItemMO
            case is DecorationImageItem:
                managedObject = PersistentManager.shared.insertObject(.decorationImageItemMO) as? DecorationItemMO
            case is DecorationStickerItem:
                managedObject = PersistentManager.shared.insertObject(.decorationStickerItem) as? DecorationItemMO
            default:
                return
            }

            if let managedObject = managedObject {
                managedObject.make(item: item)
                diaryMO.addToContents(managedObject)
            }
        }
    }
}
