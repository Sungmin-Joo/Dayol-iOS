//
//  DecorationTextFieldItemMO+CoreDataClass.swift
//  
//
//  Created by Seonho Ban on 2021/06/13.
//
//

import Foundation
import CoreData

@objc(DecorationTextFieldItemMO)
public class DecorationTextFieldItemMO: DecorationItemMO {

    override func make(item: DecorationItem) {
        super.make(item: item)

        if let textFieldItem = item as? DecorationTextFieldItem {
            self.textData = textFieldItem.textData
            self.bulletType = textFieldItem.bulletType
        }
    }

    override var toModel: DecorationTextFieldItem? {
        guard
            let itemModel = super.toModel,
            let textData = textData,
            let bulletType = bulletType
        else {
            return nil
        }

        return DecorationTextFieldItem(
            id: itemModel.id,
            parentId: itemModel.parentId,
            width: itemModel.width,
            height: itemModel.height,
            x: itemModel.x,
            y: itemModel.y,
            textData: textData,
            bulletType: bulletType
        )
    }
    
}
