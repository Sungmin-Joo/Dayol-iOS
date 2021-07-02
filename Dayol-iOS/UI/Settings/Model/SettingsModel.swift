//
//  SettingsModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import Foundation

enum SettingModel {

    enum Section: Int {
        case inApp
        case outApp
    }

    enum InApp: String, CaseIterable{
        case manual
        case homeOption
        case backup
        case widget
        case deleted

        var title: String {
            string(suffix: "title")
        }

        var subtitle: String {
            string(suffix: "text")
        }

        var iconResourceName: String {
            "settings_inapp_\(self.rawValue)"
        }

        var isSwitchOption: Bool {
            switch self {
            case .homeOption: return true
            default: return false
            }
        }

        func string(suffix: String) -> String {
            switch self {
            case .manual: return "setting_guide_\(suffix)".localized
            case .homeOption: return "setting_homeoption_\(suffix)".localized
            case .backup: return "setting_backup_\(suffix)".localized
            case .widget: return "setting_homewidget_\(suffix)".localized
            case .deleted: return "setting_bin_\(suffix)".localized
            }
        }

        struct CellModel: SettingCellModelProtocol {
            let identifier: String
            let title: String
            let subTitle: String
            let iconImageName: String
            let settingType: InApp
        }
    }

    enum OutApp: CaseIterable {
        case rate
        case report
        case instagram

        var title: String {
            switch self {
            case .rate: return "setting_review_title".localized
            case .report: return "setting_report_title".localized
            case .instagram: return "setting_insta_title".localized
            }
        }

        struct CellModel: SettingCellModelProtocol {
            let identifier: String
            let title: String
        }
    }

}

struct DeletedPageCellModel {
    let id: String
    let thumbnail: Data
    let title: String
    let subTitle: String
    let deletedDate: Date
}
