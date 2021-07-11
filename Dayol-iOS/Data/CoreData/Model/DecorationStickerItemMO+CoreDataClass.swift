//
//  DecorationStickerItemMO+CoreDataClass.swift
//  
//
//  Created by Seonho Ban on 2021/06/13.
//
//

import Foundation
import CoreData

@objc(DecorationStickerItemMO)
public class DecorationStickerItemMO: DecorationItemMO {

    override func make(item: DecorationItem) {
        super.make(item: item)

        if let stickerItem = item as? DecorationStickerItem {
            self.image = stickerItem.image
            self.inclination = stickerItem.inclination
        }
    }

    override var toModel: DecorationStickerItem? {
        guard
            let itemModel = super.toModel,
            let image = image
        else {
            return nil
        }

        return DecorationStickerItem(
            id: itemModel.id,
            parentId: itemModel.parentId,
            width: itemModel.width,
            height: itemModel.height,
            x: itemModel.x,
            y: itemModel.y,
            image: image,
            inclination: inclination
        )
    }
}
