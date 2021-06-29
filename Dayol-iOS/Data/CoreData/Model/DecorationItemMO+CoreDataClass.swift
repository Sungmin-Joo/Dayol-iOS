//
//  DecorationItemMO+CoreDataClass.swift
//  
//
//  Created by Seonho Ban on 2021/06/13.
//
//

import Foundation
import CoreData

@objc(DecorationItemMO)
public class DecorationItemMO: NSManagedObject {

    func set(_ item: DecorationItem) {
        self.id = item.id
        self.parentId = item.parentId
        self.width = item.width
        self.height = item.height
        self.x = item.x
        self.y = item.y
    }

    func getItem() -> DecorationItem? {
        guard
            let id = id,
            let parentId = parentId
        else { return nil }

        return DecorationItem(id: id,
                              parentId: parentId,
                              width: width,
                              height: height,
                              x: x,
                              y: y)
    }
}
