//
//  SettingsDetailViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/09.
//

import RxSwift
import RxCocoa

private enum Text {
    static func title(_ type: SettingModel.InApp) -> String {
        switch type {
        case .manual:
            return "Settings.Detail.Title.Manual".localized
        case .backup:
            return "Settings.Detail.Title.Backup".localized
        case .widget:
            return "Settings.Detail.Title.Widget".localized
        case .deleted:
            return "Settings.Detail.Title.Deleted".localized
        }
    }
}

class SettingsDetailViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let settingType: SettingModel.InApp

    // MARK: UI Property
    
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(settingType: SettingModel.InApp) {
        self.settingType = settingType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initView()
        setConstraints()
        bindEvent()
    }

}

// MARK: - Private Initial Extension

private extension SettingsDetailViewController {

    func setupNavigationBar() {
        let title = Text.title(settingType)
        let titleView = DYNavigationItemCreator.titleView(title)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.titleView = titleView
    }

    func initView() {
        view.addSubview(contentView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func bindEvent() {
        leftButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

}
