//
//  DiaryMO+CoreDataClass.swift
//  
//
//  Created by Seonho Ban on 2021/06/13.
//
//

import Foundation
import CoreData

@objc(DiaryMO)
public class DiaryMO: NSManagedObject {
    func set(_ diary: Diary) {
        id = diary.id
        isLock = diary.isLock
        title = diary.title
        colorHex = diary.colorHex
        hasLogo = diary.hasLogo
        thumbnail = diary.thumbnail
        drawCanvas = diary.drawCanvas
    }

    func getDiary() -> Diary? {
        guard
            let id = id,
            let title = title,
            let colorHex =  colorHex,
            let thumbnail = thumbnail,
            let drawCanvas = drawCanvas
        else { return nil }

        guard let contentsMOList = contents?.array as? [DecorationItemMO] else {
            return nil
        }

        let contents = contentsMOList.compactMap { $0.getItem() }

        return  Diary(
            id: id,
            isLock: isLock,
            title: title,
            colorHex: colorHex,
            hasLogo: hasLogo,
            thumbnail: thumbnail,
            drawCanvas: drawCanvas,
            contents: contents
        )
    }
}
