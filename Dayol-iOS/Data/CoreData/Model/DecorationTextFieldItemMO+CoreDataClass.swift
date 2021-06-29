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

    override func set(_ item: DecorationItem) {
        super.set(item)

        if let textFieldItem = item as? DecorationTextFieldItem {
            self.textData = textFieldItem.textData
        }
    }

    override func getItem() -> DecorationTextFieldItem? {
        guard
            let itemDAO = super.getItem(),
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
