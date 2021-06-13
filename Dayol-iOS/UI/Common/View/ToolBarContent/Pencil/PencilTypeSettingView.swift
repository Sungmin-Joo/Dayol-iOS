//
//  PencilTypeSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/18.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

private enum Design {
    static let contentLeftMargin: CGFloat = 20.0
    static let contentRightMargin: CGFloat = 20.0

    static let titleFont = UIFont.appleBold(size: 15)
    static let titleLineSpacing: CGFloat = -0.28

    static let penOnImage = Assets.Image.ToolBar.Pencil.penOn
    static let penOffImage = Assets.Image.ToolBar.Pencil.penOff
    static let highlightOnImage = Assets.Image.ToolBar.Pencil.highlightOn
    static let highlightOffImage = Assets.Image.ToolBar.Pencil.highlightOff

    enum OptionStackView {
        static let buttonSize = CGSize(width: 130, height: 35)
        static let spacing: CGFloat = 1.0
        static let borderWidth: CGFloat = 1.0
        static let borderColor: UIColor = .gray400
        static let cornerRadius: CGFloat = 4.0
    }

    static func titleAttributedText(_ text: String, isSelected: Bool = true) -> NSAttributedString {
        let textColor: UIColor = isSelected ? .gray900 : .gray600
        return NSAttributedString.build(text: text,
                                        font: Design.titleFont,
                                        align: .left,
                                        letterSpacing: Design.titleLineSpacing,
                                        foregroundColor: textColor)
    }
}

private enum Text {
    static var pencilTypeTitle: String {
        return "edit_pen_type".localized
    }
    static var pen: String {
        return "edit_pen_pen".localized
    }
    static var highlighter: String {
        return "edit_pen_highlighter".localized
    }
}

class PencilTypeSettingView: UIView {

    enum PencilType {
        case pen, highlighter
    }

    private let disposeBag = DisposeBag()
    private var cancellable: [AnyCancellable] = []
    let pencilTypeSubject = CurrentValueSubject<PencilType, Never>(.pen)

    // MARK: UI Property

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = Design.titleAttributedText(Text.pencilTypeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let penButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.penOnImage, for: .selected)
        button.setImage(Design.penOffImage, for: .normal)
        button.setAttributedTitle(Design.titleAttributedText(Text.pen), for: .selected)
        button.setAttributedTitle(Design.titleAttributedText(Text.pen, isSelected: false), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return  button
    }()

    private let highlightButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.highlightOnImage, for: .selected)
        button.setImage(Design.highlightOffImage, for: .normal)
        button.setAttributedTitle(Design.titleAttributedText(Text.highlighter), for: .selected)
        button.setAttributedTitle(Design.titleAttributedText(Text.highlighter, isSelected: false), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return  button
    }()

    private lazy var pencilOpionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [penButton, highlightButton])
        stackView.spacing = Design.OptionStackView.spacing
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = Design.OptionStackView.borderWidth
        stackView.layer.borderColor = Design.OptionStackView.borderColor.cgColor
        stackView.layer.cornerRadius = Design.OptionStackView.cornerRadius
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, pencilOpionStackView])
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PencilTypeSettingView {

    private func initView() {
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            penButton.widthAnchor.constraint(equalToConstant: Design.OptionStackView.buttonSize.width),
            penButton.heightAnchor.constraint(equalToConstant: Design.OptionStackView.buttonSize.height),
            highlightButton.widthAnchor.constraint(equalToConstant: Design.OptionStackView.buttonSize.width),
            highlightButton.heightAnchor.constraint(equalToConstant: Design.OptionStackView.buttonSize.height),

            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.contentLeftMargin),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Design.contentRightMargin),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindEvent() {
        pencilTypeSubject.sink { [weak self] value in
            guard let self = self else { return }

            let isPen = value == .pen
            if isPen {
                self.penButton.isSelected = true
                self.penButton.backgroundColor = .white
                self.highlightButton.isSelected = false
                self.highlightButton.backgroundColor = .clear
            } else {
                self.penButton.isSelected = false
                self.penButton.backgroundColor = .clear
                self.highlightButton.isSelected = true
                self.highlightButton.backgroundColor = .white
            }
        }
        .store(in: &cancellable)

        penButton.rx.tap
            .bind { [weak self] in
                self?.pencilTypeSubject.send(.pen)
            }
            .disposed(by: disposeBag)

        highlightButton.rx.tap
            .bind { [weak self] in
                self?.pencilTypeSubject.send(.highlighter)
            }
            .disposed(by: disposeBag)
    }

}
