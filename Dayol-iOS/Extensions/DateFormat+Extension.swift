//
//  DateFormat+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import Foundation

extension DateFormatter {
    static var yearMonthDay: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M dd"

        return dateFormatter
    }

    static var yearMonth: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M"

        return dateFormatter
    }

    static var year: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter
    }

    static var month: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"

        return dateFormatter
    }

    static var day: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        return dateFormatter
    }
}
