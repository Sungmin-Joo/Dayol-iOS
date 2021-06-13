//
//  DYFlexibleTextFieldViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/05/31.
//

import Foundation
import Combine

class DYFlexibleTextFieldViewModel {
    // TODO: bullet을 NSAttachment로 구현
    let leadingAccessoryTypeSubject = CurrentValueSubject<DYTextBoxBulletPoint.BulletType, Never>(.none)
    var didSetAttributedString: ((NSAttributedString) -> Void)?

    init(
        leadingAccessoryType: DYTextBoxBulletPoint.BulletType = .none
    ) {
        self.leadingAccessoryTypeSubject.send(leadingAccessoryType)
    }

}

// MARK: - Data

extension DYFlexibleTextFieldViewModel {

    func toItem(id: String, parentId: String, text: NSAttributedString, x: Float, y: Float, width: Float, height: Float) -> DecorationTextFieldItem? {
        let range = NSRange(location: 0, length: text.length)
        do {
            let data = try text.data(from: range,
                                     documentAttributes: [
                                        .documentType: NSAttributedString.DocumentType.rtfd
                                     ])
            return DecorationTextFieldItem(id: id,
                                           parentId: parentId,
                                           width: width,
                                           height: height,
                                           x: x,
                                           y: y,
                                           textData: data)
        } catch {
            return nil
        }
    }

    func set(_ item: DecorationTextFieldItem) {
        if let attributedText = try? NSAttributedString(data: item.textData, documentAttributes: nil) {
            didSetAttributedString?(attributedText)
        }
    }


}
