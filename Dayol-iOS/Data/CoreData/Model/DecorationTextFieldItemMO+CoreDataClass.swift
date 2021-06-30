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
        }
    }

    override var toModel: DecorationTextFieldItem? {
        guard
            let itemDAO = super.toModel,
            let textData = textData
        else { return nil }

        return DecorationTextFieldItem(id: itemDAO.id,
                                       parentId: itemDAO.parentId,
                                       width: width,
                                       height: height,
                                       x: x,
                                       y: y,
                                       textData: textData)
    }
    
}
