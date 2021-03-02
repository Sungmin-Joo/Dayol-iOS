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
        case backup
        case widget
        case deleted

        var title: String {
            string(suffix: "Title")
        }

        var subtitle: String {
            string(suffix: "Subtitle")
        }

        var iconResourceName: String {
            "settings_inapp_\(self.rawValue)"
        }

        func string(suffix: String) -> String {
            switch self {
            case .manual: return "Settings.Inapp.Manual.\(suffix)".localized
            case .backup: return "Settings.Inapp.Backup.\(suffix)".localized
            case .widget: return "Settings.Inapp.Widget.\(suffix)".localized
            case .deleted: return "Settings.Inapp.Deleted.\(suffix)".localized
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
            case .rate: return "Settings.Outapp.Rate".localized
            case .report: return "Settings.Outapp.Report".localized
            case .instagram: return "Settings.Outapp.Instagram".localized
            }
        }

        struct CellModel: SettingCellModelProtocol {
            let identifier: String
            let title: String
        }
    }

}

struct DeletedPageCellModel {
    // 추후 필요하다면 이미지? 혹은 Data 형태로 교체해야할 듯..
    let thumbnailImageName: String
    let paperType: PaperType
    let diaryName: String
    let deletedDate: Date

    var title: String {
        return paperType.title
    }
}
