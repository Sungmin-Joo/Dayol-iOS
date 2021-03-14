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
    private var scaleDownDuration: TimeInterval = 0.05
    private var scaleUpDudation: TimeInterval = 0.25
    private var highlightedScale: CGFloat = 0.9
    
	override var isHighlighted: Bool {
		didSet {
            
            if isHighlighted {
                layer.cornerRadius = 0
                layer.borderWidth = 0
                layer.masksToBounds = true
                animateSclae(to: highlightedScale, duration: scaleDownDuration)
            } else {
                layer.cornerRadius = delete ? 0 : Design.buttonRadius
                layer.borderWidth = delete ? 0 : Design.buttonBorderWidth
                layer.masksToBounds = true
                animateSclae(to: 1, duration: scaleUpDudation)
            }
            swapImage()
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
    
    private func animateSclae(to scale: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.transform = .init(scaleX: scale, y: scale)
                       },
                       completion: nil
        )
    }
    
    private func swapImage() {
        if delete {
            setImage(isHighlighted ? Design.passwordImage : Design.deleteButtonImage, for: .normal)
        } else {
            setImage(isHighlighted ? Design.passwordImage : nil, for: .normal)
        }
    }
}
