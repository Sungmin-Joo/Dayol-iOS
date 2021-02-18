//
//  DataBackupView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/17.
//

import RxSwift
import RxCocoa

private enum Design {
    static let contentBGColor = UIColor.white

    static let infoColor = UIColor(decimalRed: 34, green: 34, blue: 34)
    static let infoFont = UIFont.appleRegular(size: 15.0)
    static let infoBoldFont = UIFont.appleBold(size: 15.0)
    static let infoSpacing: CGFloat = -0.28

    static let warningColor = UIColor(decimalRed: 233, green: 77, blue: 77)
    static let warningFont = UIFont.appleRegular(size: 14.0)
    static let warningSpacing: CGFloat = -0.26

    static let infoLabelInset = UIEdgeInsets(top: 24, left: 20, bottom: 0, right: 20)
    static let warningLabelInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)

    static let iCloudContentInset = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
    static let iCloudContentHeight: CGFloat = 56.0

    static let backupExportContentInset = UIEdgeInsets(top: 13, left: 20, bottom: 0, right: 20)
    static let backupExportContentHeight: CGFloat = 162.0
}

private enum Text {
    static let info = "backup_text".localized
    static let warning = "backup_text2".localized

    static var infoBoldFirstRange: NSRange {
        let nsString = NSString(string: info)
        return nsString.range(of: "backup_text_bold1".localized)
    }
    static var infoBoldSecondRange: NSRange {
        let nsString = NSString(string: info)
        return nsString.range(of: "backup_text_bold2".localized)
    }
}

class DataBackupView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel = DataBackupViewModel()

    // MARK: UI Porperty

    private let infoLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString.build(text: Text.info,
                                                               font:  Design.infoFont,
                                                               align: .left,
                                                               letterSpacing: Design.infoSpacing,
                                                               foregroundColor: Design.infoColor)
        attributedString.addAttribute(.font,
                                      value: Design.infoBoldFont,
                                      range: Text.infoBoldFirstRange)
        attributedString.addAttribute(.font,
                                      value: Design.infoBoldFont,
                                      range: Text.infoBoldSecondRange)
        label.attributedText = attributedString
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let warningLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString.build(text: Text.warning,
                                                               font:  Design.warningFont,
                                                               align: .left,
                                                               letterSpacing: Design.warningSpacing,
                                                               foregroundColor: Design.warningColor)
        label.attributedText = attributedString
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let iCloudContentView: DataBackupCloudContentView = {
        let view = DataBackupCloudContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let backupExportContentView: DataBackupExportContentView = {
        let view = DataBackupExportContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Private initial function

private extension DataBackupView {

    func initView() {
        backgroundColor = Design.contentBGColor
        addSubview(infoLabel)
        addSubview(warningLabel)
        addSubview(iCloudContentView)
        addSubview(backupExportContentView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: Design.infoLabelInset.top),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: Design.infoLabelInset.left),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -Design.infoLabelInset.right),

            warningLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor,
                                              constant: Design.warningLabelInset.top),
            warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: Design.warningLabelInset.left),
            warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -Design.warningLabelInset.right),

            iCloudContentView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor,
                                                        constant: Design.iCloudContentInset.top),
            iCloudContentView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                            constant: Design.iCloudContentInset.left),
            iCloudContentView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                             constant: -Design.iCloudContentInset.right),
            iCloudContentView.heightAnchor.constraint(equalToConstant: Design.iCloudContentHeight),

            backupExportContentView.topAnchor.constraint(equalTo: iCloudContentView.bottomAnchor,
                                                        constant: Design.backupExportContentInset.top),
            backupExportContentView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                            constant: Design.backupExportContentInset.left),
            backupExportContentView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                             constant: -Design.backupExportContentInset.right),
            backupExportContentView.heightAnchor.constraint(equalToConstant: Design.backupExportContentHeight)
        ])
    }

    func bindEvent() {
        iCloudContentView.actionSwitch.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                // TODO: - iCloud 동기화
            })
            .disposed(by: disposeBag)

        backupExportContentView.titleTapGesture.rx.event
            .bind(onNext: { recognizer in
                guard recognizer.state == .recognized else { return }
                // TODO: - 백업파일 내보내기
            })
            .disposed(by: disposeBag)
    }
}
