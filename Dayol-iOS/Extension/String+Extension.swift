//
//  String+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }

}
