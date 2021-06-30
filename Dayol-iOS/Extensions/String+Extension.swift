//
//  String+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import Foundation

extension String {

    /// For Localize
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
    /// For Date
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func asDate(dateType: DateType) -> Date? {
        return dateType.formatter.date(from: self)
    }
}
