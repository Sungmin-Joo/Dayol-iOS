//
//  DecorationImageItemMO+CoreDataClass.swift
//  
//
//  Created by Seonho Ban on 2021/06/13.
//
//

import Foundation
import CoreData

@objc(DecorationImageItemMO)
public class DecorationImageItemMO: DecorationItemMO {

    override func make(item: DecorationItem) {
        super.make(item: item)

        if let imageItem = item as? DecorationImageItem {
            self.image = imageItem.image
            self.inclination = imageItem.inclination
        }
    }

    override var toModel: DecorationImageItem? {
        guard
            let itemModel = super.toModel,
            let image = image
        else {
            return nil
        }

        return DecorationImageItem(
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
