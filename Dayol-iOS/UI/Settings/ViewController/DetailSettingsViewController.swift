//
//  SettingsDetailViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/09.
//

import RxSwift
import RxCocoa

private enum Design {
    static let clearButtonTextColor = UIColor(decimalRed: 233, green: 77, blue: 77)
}

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
    static let deleteAllButton = "비우기"
    static let alertTitle = "휴지통 비우기"
    static let alertMessage = "휴지통의 모든 내용이 영구 삭제됩니다.\n삭제 후에는 복구가 불가능합니다."
    static let alertCancel = "취소"
    static let alertDefault = "전체 삭제"
}

class DetailSettingsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let settingType: SettingModel.InApp

    // MARK: UI Property
    
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private var contentView: UIView?

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

    @objc func didTapDeleteAllButton() {
        guard let deletedPageView = contentView as? DeletedPageListView else { return }
        let alert = DayolAlertController(title: Text.alertTitle, message: Text.alertMessage)
        let cancelAction = DayolAlertAction(title: Text.alertCancel, style: .cancel)
        let action = DayolAlertAction(title: Text.alertDefault, style: .default) {
            deletedPageView.didTapDeleteAllButton()
        }

        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true)
    }

}

// MARK: - Private Initial Extension

private extension DetailSettingsViewController {

    func setupNavigationBar() {
        let title = Text.title(settingType)
        let titleView = DYNavigationItemCreator.titleView(title)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.titleView = titleView
    }

    func initView() {
        switch settingType {
        case .manual:
            contentView = UIView()
        case .backup:
            contentView = UIView()
        case .widget:
            contentView = UIView()
        case .deleted:
            let deletedPageListView = DeletedPageListView()
            deletedPageListView.isEmpty
                .subscribe(onNext: { [weak self] isEmpty in
                    let isEnabled = isEmpty == false
                    self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
                })
                .disposed(by: disposeBag)
            contentView = deletedPageListView

            setDeleteAllButton()
        }

        if let contentView = contentView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(contentView)
        }
    }

    func setDeleteAllButton() {
        let item = UIBarButtonItem(title: Text.deleteAllButton, style: .plain, target: self, action: #selector(didTapDeleteAllButton))
        item.tintColor = Design.clearButtonTextColor

        navigationItem.rightBarButtonItem = item
    }

    func setConstraints() {
        guard let contentView = contentView else { return }

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
