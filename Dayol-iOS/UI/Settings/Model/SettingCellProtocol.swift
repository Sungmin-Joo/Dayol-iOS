//
//  SettingCellProtocol.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/08.
//

import UIKit

protocol SettingCellPresentable: UITableViewCell {
    var viewModel: SettingCellModelProtocol? { get set }
    func configuration(_ viewModel: SettingCellModelProtocol?)
}

protocol SettingCellModelProtocol {
    var identifier: String { get }
    var title: String { get }
}
