//
//  DayolAlertAction.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

extension DayolAlertAction {

    public enum Style {

        case `default`

        case cancel

    }
}

final class DayolAlertAction {

    private(set) var title: String
    private(set) var style: DayolAlertAction.Style
    private(set) var handler: (() -> Void)?

    init(
        title: String,
        style: DayolAlertAction.Style,
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }

}
