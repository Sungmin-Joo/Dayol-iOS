//
//  PasswordButton.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/14.
//

import UIKit
import RxCocoa
import RxSwift

private enum Design {
	static let buttonFont: UIFont? = UIFont(name: "DXRMbxStd-B", size: 30.0)
	static let passwordImage: UIImage? = UIImage(named: "password_dayol")

	static let buttonInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 0.0)
	static let buttonRadius: CGFloat = 29.0
	static let buttonBorderWidth: CGFloat = 2.0
	static let buttonBorderColor: CGColor = UIColor.black.cgColor
	static let buttonSize: CGSize = CGSize(width: 58, height: 58)

	static let deleteButtonImage: UIImage? = UIImage(named: "password_delete")
}

class PasswordButton: UIButton {
	private var text: String
	private var delete: Bool
	private let disposeBag = DisposeBag()

	override var isHighlighted: Bool {
		didSet {
			if delete == false {
				layer.cornerRadius = isHighlighted ? 0.0 : Design.buttonRadius
				layer.borderWidth = isHighlighted ? 0.0 : Design.buttonBorderWidth
			}
		}
	}

	init(text: String = "", isDelete: Bool = false) {
		self.text = text
		self.delete = isDelete
		super.init(frame: .zero)
		initButton()
	}

	private override init(frame: CGRect) {
		self.text = ""
		self.delete = false
		super.init(frame: frame)
		initButton()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initButton() {
		setImage(Design.passwordImage, for: .highlighted)

		if delete {
			setImage(Design.deleteButtonImage, for: .normal)
		} else {
			titleLabel?.font = Design.buttonFont
			setTitle(text, for: .normal)
			setTitleColor(.black, for: .normal)
			contentEdgeInsets = Design.buttonInset
			layer.borderWidth = Design.buttonBorderWidth
			layer.cornerRadius = Design.buttonRadius
			layer.borderColor = Design.buttonBorderColor
			layer.masksToBounds = true
		}

		translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
			heightAnchor.constraint(equalToConstant: Design.buttonSize.height)
		])
	}
}
