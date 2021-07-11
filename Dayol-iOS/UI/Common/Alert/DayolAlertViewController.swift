//
//  DayolAlertViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/12.
//

import UIKit

final class DayolAlertController: DYViewController, PopupPresentDelegate {

    // MARK: Property
    private var actions: [DayolAlertAction.Style: DayolAlertAction] = [:]
    var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.Color.dimBG
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.Color.alertBG
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Design.Constant.alertRadius
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Design.Constant.messageLabelNumberOfLines
        return label
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = Design.Constant.buttonStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let defaultButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Design.Color.alertMain
        button.setAttributedTitle(Design.AttributedText.defaultButton(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Design.Constant.buttonRadius
        return button
    }()
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(Design.AttributedText.cancelButton(), for: .normal)
        button.backgroundColor = Design.Color.cancelButtonBG
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Design.Constant.buttonRadius
        button.layer.borderColor = Design.Color.alertMain.cgColor
        button.layer.borderWidth = Design.Constant.cancelButtonBorderWidth
        return button
    }()
    override var title: String? {
        didSet {
            guard let title = title else { return }
            setTitleLabel(text: title)
        }
    }
    var message: String? {
        didSet {
            guard let message = message else { return }
            setMessageLabel(text: message)
        }
    }

    // MARK: Initialize
    convenience init(title: String, message: String) {
        self.init()
        self.title = title
        self.message = message
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve

        setTitleLabel(text: title)
        setMessageLabel(text: message)
        setDefaultButton()
    }

    // MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        setupViews()
        setupLayoutConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard title != nil, message != nil else {
            fatalError(Design.Text.titleError)
        }
        presentPopup(animated: animated)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissPopup(animated: flag) {
            /*
             하위뷰가 dismiss되기 전에 viewcontroller가 먼저 dismiss되는 현상을 막기위한 completionHandler
             순서 바뀔 쉬 크래시 유발.

             animated = true일 경우 dismissPopup(animated:)에서 애니메이션을 수행하기 때문에
             super.dismiss 호출 시 animated를 항상 false로 설정
             (true로 설정 시 Popup이 사라진 뒤에 살짝 딜레이가 있음)
             */
            super.dismiss(animated: false, completion: completion)
        }
    }

}

// MARK: - Public Funtions
extension DayolAlertController {

    func addAction(_ action: DayolAlertAction) {
        let title = action.title

        actions[action.style] = action

        if action.style == .default {
            setDefaultButton(text: title)
        } else {
            setCancelButton(text: title)
        }
    }

}

// MARK: - Action
extension DayolAlertController {

    @objc func didTapDefaultButton() {
        dismiss(animated: true) {
            guard let action = self.actions[.default] else { return }
            action.handler?()
        }
    }

    @objc func didTapCancelButton() {
        dismiss(animated: true) {
            guard let action = self.actions[.cancel] else { return }
            action.handler?()
        }
    }

}

// MARK: - Setup Views
extension DayolAlertController {

    private func setDefaultButton() {
        buttonStackView.addArrangedSubview(defaultButton)
    }

    private func setupViews() {
        view.addSubview(dimmView)
        view.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
    }

    private func setupAction() {
        defaultButton.addTarget(self,
                                action: #selector(didTapDefaultButton),
                                for: .touchUpInside)
        cancelButton.addTarget(self,
                               action: #selector(didTapCancelButton),
                               for: .touchUpInside)
    }

    private func setTitleLabel(text: String) {
        titleLabel.attributedText = Design.AttributedText.title(text)
    }

    private func setMessageLabel(text: String) {
        messageLabel.attributedText = Design.AttributedText.message(text)
    }

    private func setDefaultButton(text: String) {
        defaultButton.setAttributedTitle(Design.AttributedText.defaultButton(text), for: .normal)
        defaultButton.removeFromSuperview()
        buttonStackView.addArrangedSubview(defaultButton)
    }

    private func setCancelButton(text: String) {
        cancelButton.setAttributedTitle(Design.AttributedText.cancelButton(text), for: .normal)
        cancelButton.removeFromSuperview()
        buttonStackView.addArrangedSubview(cancelButton)
    }

}

// MARK: - Layout Constraints
extension DayolAlertController {

    private func setupLayoutConstraints() {

        NSLayoutConstraint.activate([
            dimmView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: Design.Constant.alertSize.width),
            containerView.heightAnchor.constraint(equalToConstant: Design.Constant.alertSize.height),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                            constant: Design.Constant.titleLabelTopMargin),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                              constant: Design.Constant.messageLabelTopMargin),
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                  constant: Design.Constant.messageLabelLeading),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -Design.Constant.messageLabelTrailing),

            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                    constant: -Design.Constant.buttonStackViewBottomMargin),
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            defaultButton.widthAnchor.constraint(equalToConstant: Design.Constant.buttonWidth),
            defaultButton.heightAnchor.constraint(equalToConstant: Design.Constant.buttonHeight),
            cancelButton.widthAnchor.constraint(equalToConstant: Design.Constant.buttonWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: Design.Constant.buttonHeight)

        ])

    }

}

// MARK: - Design
extension DayolAlertController {

    private enum Design {
        enum Text {
            static let titleError = "DayolAlertViewController must have title, message to display"
            static let defaultButton = "확인"
            static let cancel = "취소"
        }

        enum AttributedText {
            static func title(_ text: String) -> NSAttributedString {
                let attributedText = NSAttributedString(string: text, attributes: Attributes.title)
                return attributedText
            }
            static func message(_ text: String) -> NSAttributedString {
                let attributedText = NSAttributedString(string: text, attributes: Attributes.message)
                return attributedText
            }
            static func defaultButton(_ text: String = Text.defaultButton) -> NSAttributedString {
                let attributedText = NSMutableAttributedString(string: text,
                                                               attributes: Attributes.buttonTitle)
                attributedText.addAttribute(.foregroundColor,
                                            value: Color.defaultButtonFG,
                                            range: NSRange(location: 0, length: text.count))
                return attributedText
            }
            static func cancelButton(_ text: String = Text.cancel) -> NSAttributedString {
                let attributedText = NSMutableAttributedString(string: text,
                                                               attributes: Attributes.buttonTitle)
                attributedText.addAttribute(.foregroundColor,
                                            value: Color.cancelButtonFG,
                                            range: NSRange(location: 0, length: text.count))
                return attributedText
            }
        }

        enum Attributes {
            static let alertParagraphStyle: NSMutableParagraphStyle = {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.center
                return paragraphStyle
            }()
            static let title: [NSAttributedString.Key: Any] = {
                let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: alertParagraphStyle,
                    .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor: Color.title,
                    .kern: -0.37
                ]
                return attributes
            }()
            static let message: [NSAttributedString.Key: Any] = {
                let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: alertParagraphStyle,
                    .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                    .foregroundColor: Color.message,
                    .kern: -0.28
                ]
                return attributes
            }()
            static let buttonTitle: [NSAttributedString.Key: Any] = {
                let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: alertParagraphStyle,
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                    .kern: -0.3
                ]
                return attributes
            }()
        }

        enum Constant {
            static let alertSize = CGSize(width: 320, height: 214)
            static let alertRadius: CGFloat = 8.0
            static let titleLabelTopMargin: CGFloat = 30.0
            static let messageLabelTopMargin: CGFloat = 20.0
            static let messageLabelNumberOfLines = 2
            static let messageLabelLeading: CGFloat = 20.0
            static let messageLabelTrailing: CGFloat = 20.0
            static let buttonStackViewSpacing: CGFloat = 10.0
            static let buttonStackViewBottomMargin: CGFloat = 20.0
            static let buttonWidth: CGFloat = 125.0
            static let buttonHeight: CGFloat = 50.0
            static let buttonRadius: CGFloat = 6.0
            static let cancelButtonBorderWidth: CGFloat = 1.0
        }

        // TODO: - color 컨벤션 정해지면 수정
        enum Color {
            static let alertMain = UIColor(red: 187.0 / 255.0,
                                           green: 120.0 / 255.0,
                                           blue: 76.0 / 255.0,
                                           alpha: 1.0)
            static let dimBG = UIColor.black.withAlphaComponent(0.6)
            static let alertBG = UIColor.white
            static let title = UIColor.black
            static let message = UIColor(red: 102.0 / 255.0,
                                         green: 102.0 / 255.0,
                                         blue: 102.0 / 255.0,
                                         alpha: 1.0)
            static let defaultButtonFG = UIColor.white
            static let defaultButtonBG = alertMain
            static let cancelButtonFG = alertMain
            static let cancelButtonBG = UIColor.white
        }
    }

}
