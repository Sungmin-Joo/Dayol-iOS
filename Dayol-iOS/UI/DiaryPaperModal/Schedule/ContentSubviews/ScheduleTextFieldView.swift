//
//  ScheduleTextFieldView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/10.
//

import UIKit

private enum Design {
    enum Label {
        static let textFont = UIFont.appleRegular(size: 17)
        static let placeHolerColor = UIColor.gray500
        static let textColor = UIColor.gray900
        static let letterSpace: CGFloat = -0.31
        static let maxTextLength: Int = 10
    }

    enum View {
        static let underLineColor: UIColor = .black
    }

    enum Margin {
        static let underLineTextSpace: CGFloat = 10
    }

    enum Size {
        static let underLineHeight: CGFloat = 1
    }
}

private enum Text: String {
    case placeHolder = "일정을 입력하세요. (최대 10자)"
}

final class ScheduleTextFieldView: UIView {
    // MARK: - UI Component

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString.build(text: Text.placeHolder.rawValue,
                                                                   font: Design.Label.textFont,
                                                                   align: .natural,
                                                                   letterSpacing: Design.Label.letterSpace,
                                                                   foregroundColor: Design.Label.placeHolerColor)
        return textField
    }()

    private let underLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.View.underLineColor

        return view
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(textField)
        addSubview(underLine)

        textField.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),

            underLine.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Design.Margin.underLineTextSpace),
            underLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            underLine.heightAnchor.constraint(equalToConstant: Design.Size.underLineHeight),
            underLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ScheduleTextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= Design.Label.maxTextLength
    }
}
