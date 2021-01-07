//
//  SettingsViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import Foundation

class SettingsViewModel {
    private(set) var settings: [SettingModel.Section: [SettingCellModelProtocol]] = [:]

    init() {
        settings[.inApp] = SettingModel.InApp.allCases.map {
            SettingModel.InApp.CellModel(identifier: InAppSettingCell.className,
                                         title: $0.title,
                                         subTitle: $0.subtitle,
                                         iconImageName: $0.iconResourceName)
        }

        settings[.outApp] = SettingModel.OutApp.allCases.map {
            SettingModel.OutApp.CellModel(identifier: OutAppSettingCell.className,
                                          title: $0.title)
        }
    }
}

extension SettingsViewModel {

    var numberOfRowsInSection: Int {
        settings.keys.count
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let section = SettingModel.Section(rawValue: section) else { return 0 }
        return settings[section]?.count ?? 0
    }

    func cellModel(_ indexPath: IndexPath) -> SettingCellModelProtocol? {
        guard
            let section = SettingModel.Section(rawValue: indexPath.section),
            let cellModel = settings[section]?[safe: indexPath.row]
        else { return nil }

        return cellModel
    }

}
