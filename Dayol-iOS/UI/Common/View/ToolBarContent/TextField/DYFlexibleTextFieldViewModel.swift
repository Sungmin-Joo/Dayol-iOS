//
//  DYFlexibleTextFieldViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/05/31.
//

import Foundation
import Combine

class DYFlexibleTextFieldViewModel: NSObject {
    let id: String
    var isFitStyle: Bool
    var text: NSAttributedString
    let leadingAccessoryTypeSubject = CurrentValueSubject<DYTextBoxBulletPoint.BulletType, Never>(.none)

    init(
        id: String = "",
        isFitStyle: Bool,
        text: NSAttributedString = NSAttributedString(),
        leadingAccessoryType: DYTextBoxBulletPoint.BulletType = .none
    ) {
        self.id = id
        self.isFitStyle = isFitStyle
        self.text = text
        self.leadingAccessoryTypeSubject.send(leadingAccessoryType)
    }

}

// MARK: - Data

extension DYFlexibleTextField {
//    var toTextFieldItem: DecorationTextFieldItem {
//        let item = DecorationTextFieldItem()
//        return item
//    }

}
