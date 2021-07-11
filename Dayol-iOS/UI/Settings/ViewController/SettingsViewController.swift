//
//  SettingsViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    enum BannerImage {
        static func banner(type: UserActivityType) -> UIImage? {
            switch type {
            case .new: return UIImage(namedByLanguage: "imgMembership_banner_unsubscribed")
            case .subscriber: return UIImage(namedByLanguage: "imgMembership_banner_subscriber")
            case .expiredSubscriber: return UIImage(namedByLanguage: "imgMembership_banner_resubscribe")
            }
        }

        static var bannerRefSize: CGSize {
            if isIPad {
                return CGSize(width: 375, height: 667)
            } else {
                return UIScreen.main.bounds.size
            }
        }
    }
    static let bachgroundColor = UIColor.white

    static let sectionHeaderViewHeight: CGFloat = 20.0
    static let sectionHeaderViewLineHeight: CGFloat = 1.0
    static let sectionHeaderViewLineMargin: CGFloat = 24.0
    static let sectionHeaderViewLineColor = UIColor.gray400
}

class SettingsViewController: DYViewController {

    static let localizedTitle = "Settings".localized

    private let disposeBag = DisposeBag()
    private let rightButton = DYNavigationItemCreator.barButton(type: .cancel)
    private let titleView = DYNavigationItemCreator.titleView(localizedTitle)
    private let tableView = UITableView()
    private(set) var viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.bachgroundColor
        setupNavigationBar()
        setupTableView()
        setupConstraints()
        bindEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        navigationController?.navigationBar.shadowImage = nil
    }

}

// MARK: - Set Up

extension SettingsViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.titleView = titleView
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InAppSettingCell.self,
                           forCellReuseIdentifier: InAppSettingCell.identifier)
        tableView.register(OutAppSettingCell.self,
                           forCellReuseIdentifier: OutAppSettingCell.identifier)
        tableView.backgroundColor = Design.bachgroundColor
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false

        setupBanner()

        view.addSubview(tableView)
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }

    private func setupBanner() {
        let userActivityType: UserActivityType = UserActivityType(rawValue: DYUserDefaults.activityType) ?? .new
        let bannerImage: UIImage? = Design.BannerImage.banner(type: userActivityType)
        let ratio: CGFloat = bannerImage?.widthRatio ?? .zero
        let size: CGSize = CGSize(width: view.frame.width, height: view.frame.width * ratio)
        let bannerView: UIButton = UIButton(frame: CGRect(origin: .zero, size: size))
        bannerView.imageView?.contentMode = .scaleAspectFit
        bannerView.setBackgroundImage(bannerImage, for: .normal)
        bannerView.addTarget(self, action: #selector(didTapBanner), for: .touchUpInside)

        tableView.tableHeaderView = bannerView
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingModel.Section(rawValue: section) else { return 0 }
        return viewModel.settings[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.cellModel(indexPath) else {
            return UITableViewCell()
        }

        let dequeCell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath)

        guard let settingCell = dequeCell as? SettingCellPresentable else {
            return dequeCell
        }

        settingCell.viewModel = cellModel
        settingCell.selectionStyle = .none

        return settingCell
    }

}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cellModel = viewModel.cellModel(indexPath),
            let inAppCellModel = cellModel as? SettingModel.InApp.CellModel
        else { return }

        let settingType = inAppCellModel.settingType
        let detailVC = DetailSettingsViewController(settingType: settingType)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }

        let headerView = UITableViewHeaderFooterView()
        let lineView = UIView()

        lineView.backgroundColor = Design.sectionHeaderViewLineColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        headerView.contentView.addSubview(lineView)
        headerView.backgroundView = UIView()

        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: Design.sectionHeaderViewLineHeight),
            lineView.centerYAnchor.constraint(equalTo: headerView.contentView.centerYAnchor),
            lineView.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor,
                                              constant: Design.sectionHeaderViewLineMargin),
            lineView.trailingAnchor.constraint(equalTo: headerView.contentView.trailingAnchor,
                                               constant: -Design.sectionHeaderViewLineMargin)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? Design.sectionHeaderViewHeight : 0
    }
}

// MARK: - Bind Event

private extension SettingsViewController {
    func bindEvent() {
        rightButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

    @objc func didTapBanner() {
        let membershipVC = MembershipViewController()
        navigationController?.pushViewController(membershipVC, animated: true)
    }
}
