//
//  DYFlexibleTextFieldViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/05/31.
//

import Foundation
import RxSwift

class DYFlexibleTextFieldViewModel {
    private(set) var id: String
    let bulletTypeSubject = BehaviorSubject<DYTextBoxBulletPoint.BulletType>(value: .none)
    let pointSubject = ReplaySubject<(x: Float, y: Float)>.createUnbounded()
    let sizeSubject = ReplaySubject<(width: Float, height: Float)>.createUnbounded()
    let attributedTextSubject = ReplaySubject<NSAttributedString>.createUnbounded()

    init(id: String) {
        self.id = id
    }

}

// MARK: - Data

extension DYFlexibleTextFieldViewModel {

    func toItem(parentId: String, text: NSAttributedString, x: Float, y: Float, width: Float, height: Float) -> DecorationTextFieldItem? {
        let range = NSRange(location: 0, length: text.length)
        do {
            let data = try text.data(from: range,
                                     documentAttributes: [
                                        .documentType: NSAttributedString.DocumentType.rtfd
                                     ])
            let bulletType = try bulletTypeSubject.value().rawValue
            return DecorationTextFieldItem(id: id,
                                           parentId: parentId,
                                           width: width,
                                           height: height,
                                           x: x,
                                           y: y,
                                           textData: data,
                                           bulletType: bulletType)
        } catch {
            return nil
        }
    }

    func set(_ item: DecorationTextFieldItem) {
        if let attributedText = try? NSAttributedString(data: item.textData, documentAttributes: nil) {
            pointSubject.onNext((item.x, item.y))
            sizeSubject.onNext((item.width, item.height))
            attributedTextSubject.onNext(attributedText)
            id = item.id

            if let bulletType = DYTextBoxBulletPoint.BulletType(rawValue: item.bulletType) {
                bulletTypeSubject.onNext(bulletType)
            }
        }
    }

}
