//
//  DYFlexibleTextFieldViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/05/31.
//

import Foundation
import Combine

class DYFlexibleTextFieldViewModel: NSObject {
    var isFitStyle: Bool
    var text: NSAttributedString
    let leadingAccessoryTypeSubject = CurrentValueSubject<DYTextBoxBulletPoint.BulletType, Never>(.none)

    init(
        isFitStyle: Bool,
        text: NSAttributedString = NSAttributedString(),
        leadingAccessoryType: DYTextBoxBulletPoint.BulletType = .none
    ) {
        self.isFitStyle = isFitStyle
        self.text = text
        self.leadingAccessoryTypeSubject.send(leadingAccessoryType)
    }

}
