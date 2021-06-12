//
//  EraseSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/03/29.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let titleKern: CGFloat = -0.3
    static let titleFont = UIFont.appleBold(size: 16.0)
    static let titleColor = UIColor.gray900

    static let infoImage = Assets.Image.ToolBar.info
    static let infoTitleKern: CGFloat = -0.26
    static let infoTitleFont = UIFont.appleRegular(size: 14.0)
    static let infoTitleColor = UIColor.gray800
    static let infoStackViewSpacing: CGFloat = 4.0

    static let titleStackViewSpacing: CGFloat = 5.0
    static let titleStackViewTop: CGFloat = 20.0
    static let titleStackViewLeading: CGFloat = 30.0
    static let titleStackViewWidth: CGFloat = 315.0

    static let separatorViewColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorViewTopMargin: CGFloat = 20.0

    static let objectEraseOptionStackViewBottomMargin: CGFloat = 20.0
    static let objectEraseOptionStackViewSideMargin: CGFloat = 30.0

    static let objectEraseOptionTitleKern: CGFloat = -0.3
    static let objectEraseOptionTitleFont = UIFont.appleRegular(size: 16.0)
    static let objectEraseOptionBoldTitleFont = UIFont.appleBold(size: 16.0)
    static let objectEraseOptionTitleColor: UIColor = .gray900
    
}

private enum Text {
    static var infoTitle: String {
        return "edit_eraser_text".localized
    }
    static var ovjectEraseTitle: String {
        return "edit_eraser_option".localized
    }

    static var ovjectEraseBoldRange: NSRange {
        let nsString = NSString(string: ovjectEraseTitle)
        return nsString.range(of: "edit_eraser_option_bold".localized)
    }
}

class EraseSettingView: UIView {

    static let contentHeight: CGFloat = 130.0
    private let disposeBag = DisposeBag()
    private(set) var isObjectErase: Bool

    // MARK: UI Property

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = Design.titleStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let objectEraseOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var objectEraseSwitch: UISwitch = {
        let objectEraseSwitch = UISwitch()
        objectEraseSwitch.isOn = isObjectErase
        objectEraseSwitch.translatesAutoresizingMaskIntoConstraints = false
        return objectEraseSwitch
    }()

    init(isObjectErase: Bool = false) {
        self.isObjectErase = isObjectErase
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

extension EraseSettingView {

    private func initView() {
        setupTitleArea()
        setupObjectEraseSettingArea()

        objectEraseSwitch.isOn = isObjectErase
        backgroundColor = .gray100
        addSubview(separatorView)
    }

    private func setupTitleArea() {
        let infoTitleLabel = UILabel()
        infoTitleLabel.attributedText = NSAttributedString.build(text: Text.infoTitle,
                                                                 font: Design.infoTitleFont,
                                                                 align: .left,
                                                                 letterSpacing: Design.infoTitleKern,
                                                                    foregroundColor: Design.infoTitleColor)
        let infoImageView = UIImageView(image: Design.infoImage)
        let infoStackView = UIStackView(arrangedSubviews: [infoImageView, infoTitleLabel])
        infoStackView.spacing = Design.infoStackViewSpacing
        infoStackView.alignment = .center

        titleStackView.addArrangedSubview(infoStackView)

        addSubview(titleStackView)
    }

    private func setupObjectEraseSettingArea() {
        let titleLabel = UILabel()
        let attributedText = NSMutableAttributedString.build(text: Text.ovjectEraseTitle,
                                                             font: Design.objectEraseOptionTitleFont,
                                                             align: .left,
                                                             letterSpacing: Design.objectEraseOptionTitleKern,
                                                             foregroundColor: Design.objectEraseOptionTitleColor)
        attributedText.addAttribute(.font,
                                    value: Design.objectEraseOptionBoldTitleFont,
                                    range: Text.ovjectEraseBoldRange)
        titleLabel.attributedText = attributedText

        objectEraseOptionStackView.addArrangedSubview(titleLabel)
        objectEraseOptionStackView.addArrangedSubview(objectEraseSwitch)

        addSubview(objectEraseOptionStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: Design.titleStackViewLeading),
            titleStackView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: Design.titleStackViewTop),

            objectEraseOptionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                               constant: -Design.objectEraseOptionStackViewBottomMargin),
            objectEraseOptionStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                                constant: Design.objectEraseOptionStackViewSideMargin),
            objectEraseOptionStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                                constant: -Design.objectEraseOptionStackViewSideMargin),
            separatorView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor,
                                                  constant: Design.separatorViewTopMargin),
            separatorView.leadingAnchor.constraint(equalTo: objectEraseOptionStackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: objectEraseOptionStackView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func bindEvent() {
        objectEraseSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(objectEraseSwitch.rx.value)
            .subscribe { [weak self] isObjectErase in
                self?.isObjectErase = isObjectErase
            }
            .disposed(by: disposeBag)
    }

}
