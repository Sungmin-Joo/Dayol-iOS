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
    static let titleStackViewTop: CGFloat = 24.0
    static let titleStackViewLeading: CGFloat = 30.0
    static let titleStackViewWidth: CGFloat = 315.0

    static let eraseOptionStackViewTopMargin: CGFloat = 40.0
    static let eraseOptionStackViewSideMargin: CGFloat = 60.0
    static let eraseOptionTitleKern: CGFloat = -0.24
    static let eraseOptionTitleFont = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    static let eraseOptionTitleColor: UIColor = .gray800

    static let separatorViewColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorViewBottomMargin: CGFloat = 23

    static let objectEraseOptionStackViewBottomMargin: CGFloat = 20.0
    static let objectEraseOptionStackViewSideMargin: CGFloat = 30.0

    static let objectEraseOptionTitleKern: CGFloat = -0.3
    static let objectEraseOptionTitleFont = UIFont.appleRegular(size: 16.0)
    static let objectEraseOptionBoldTitleFont = UIFont.appleBold(size: 16.0)
    static let objectEraseOptionTitleColor: UIColor = .gray900

    static func eraseOptionButtonSpacing(_ eraseType: EraseType) -> CGFloat {
        switch eraseType {
        case .small: return 25.0
        case .medium: return 15.0
        case .large: return 5.0
        }
    }
    
}

enum EraseType: String, CaseIterable {
    case small, medium, large

    var image: UIImage? {
        switch self {
        case .small: return Assets.Image.ToolBar.Erase.small.image
        case .medium: return Assets.Image.ToolBar.Erase.medium.image
        case .large: return Assets.Image.ToolBar.Erase.large.image
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .small: return Assets.Image.ToolBar.Erase.small.selectedImage
        case .medium: return Assets.Image.ToolBar.Erase.medium.selectedImage
        case .large: return Assets.Image.ToolBar.Erase.large.selectedImage
        }
    }
}

private enum Text {
    static let title = "edit_eraser_size".localized
    static let infoTitle = "edit_eraser_text".localized
    static let ovjectEraseTitle = "edit_eraser_option".localized

    static var ovjectEraseBoldRange: NSRange {
        let nsString = NSString(string: ovjectEraseTitle)
        return nsString.range(of: "edit_eraser_option_bold".localized)
    }
}

class EraseSettingView: UIView {

    private let disposeBag = DisposeBag()

    private var currentEraseType: EraseType
    private var isObjectErase: Bool

    // MARK: UI Property

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = Design.titleStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let eraseOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var buttons: [EraseOptionButton] = {
        let buttons: [EraseOptionButton] = EraseType.allCases.map { eraseType in
            let spacing = Design.eraseOptionButtonSpacing(eraseType)
            let button = EraseOptionButton(spacing: spacing)
            let attributedString = NSAttributedString.build(text: eraseType.rawValue,
                                                            font: Design.eraseOptionTitleFont,
                                                            align: .center,
                                                            letterSpacing: Design.eraseOptionTitleKern,
                                                            foregroundColor: Design.eraseOptionTitleColor)
            button.setImage(eraseType.image, for: .normal)
            button.setImage(eraseType.selectedImage, for: .selected)
            button.setAttributedTitle(attributedString, for: .normal)
            button.adjustsImageWhenHighlighted = false
            button.rx.tap
                .bind { [weak self] in
                    self?.clearButtons()
                    self?.currentEraseType = eraseType
                    button.isSelected = true
                }
                .disposed(by: disposeBag)
            if currentEraseType == eraseType {
                button.isSelected = true
            }
            return button
        }
        return buttons
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

    init(currentEraseType: EraseType = .small, isObjectErase: Bool = false) {
        self.isObjectErase = isObjectErase
        self.currentEraseType = currentEraseType
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension EraseSettingView {

    private func initView() {
        setupTitleArea()
        setupEraseSettingArea()
        setupObjectEraseSettingArea()

        backgroundColor = .gray100
        addSubview(separatorView)
    }

    private func setupTitleArea() {
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString.build(text: Text.title,
                                                             font: Design.titleFont,
                                                             align: .left,
                                                             letterSpacing: Design.titleKern,
                                                                foregroundColor: Design.titleColor)
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

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(infoStackView)

        addSubview(titleStackView)
    }

    private func setupEraseSettingArea() {
        buttons.forEach { eraseOptionStackView.addArrangedSubview($0) }
        addSubview(eraseOptionStackView)
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
            titleStackView.widthAnchor.constraint(equalToConstant: Design.titleStackViewWidth),
            titleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: Design.titleStackViewLeading),
            titleStackView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: Design.titleStackViewTop),

            eraseOptionStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor,
                                                      constant: Design.eraseOptionStackViewTopMargin),
            eraseOptionStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                          constant: Design.eraseOptionStackViewSideMargin),
            eraseOptionStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -Design.eraseOptionStackViewSideMargin),

            objectEraseOptionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                               constant: -Design.objectEraseOptionStackViewBottomMargin),
            objectEraseOptionStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                                constant: Design.objectEraseOptionStackViewSideMargin),
            objectEraseOptionStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                                constant: -Design.objectEraseOptionStackViewSideMargin),
            separatorView.bottomAnchor.constraint(equalTo: objectEraseOptionStackView.topAnchor,
                                                  constant: -Design.separatorViewBottomMargin),
            separatorView.leadingAnchor.constraint(equalTo: objectEraseOptionStackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: objectEraseOptionStackView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func clearButtons() {
        buttons.forEach { $0.isSelected = false }
    }

}
