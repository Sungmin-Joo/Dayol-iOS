//
//  DYNavigationEditableTitle.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/30.
//

import UIKit
import RxCocoa
import RxSwift

private enum Design {
    static let titleFont = UIFont.appleBold(size: 19)
    static let titleSize = CGSize(width: 210, height: 40)
    static let titleLetterSpace: CGFloat = -0.35
    static let titleMaxCount = 10
    
    static let titleBackgroundColor: UIColor = UIColor(decimalRed: 245, green: 245, blue: 245)
    static let titleBorderColor: CGColor = UIColor(decimalRed: 218, green: 218, blue: 218).cgColor
    static let titleRadius: CGFloat = 4
    static let titleBorderWidth: CGFloat = 1
    
    static let editButtonImage: UIImage? = UIImage(named: "titleEditButton")
    static let editButtonSize: CGSize = CGSize(width: 14, height: 14)
}

class DYNavigationEditableTitle: DYNavigationTitle {
    var isEditting = false {
        didSet {
            updateCurrentTitle()
            changeEditMode(isEditting: isEditting)
        }
    }
    
    let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.editButtonImage, for: .normal)
        
        return button
    }()
    
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.isHidden = true
        titleTextField.returnKeyType = .done
        titleTextField.textAlignment = .center
        titleTextField.backgroundColor = Design.titleBackgroundColor
        titleTextField.layer.borderWidth = Design.titleBorderWidth
        titleTextField.layer.borderColor = Design.titleBorderColor
        titleTextField.layer.cornerRadius = Design.titleRadius
        titleTextField.layer.masksToBounds = true

        return titleTextField
    }()
    
    override init(text: String, color: UIColor) {
        super.init(text: text, color: color)
        titleTextField.attributedText = attributedText(text: text, color: color)
        horizontalStack.addArrangedSubview(editButton)
        horizontalStack.addArrangedSubview(titleTextField)
        titleTextField.delegate = self
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        let textViewHeight = titleTextField.heightAnchor.constraint(equalToConstant: Design.titleSize.height)
        textViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: Design.editButtonSize.width),
            editButton.heightAnchor.constraint(equalToConstant: Design.editButtonSize.height),
            
            titleTextField.widthAnchor.constraint(equalToConstant: Design.titleSize.width),
            textViewHeight
        ])
    }
    
    private func changeEditMode(isEditting: Bool) {
        if isEditting {
            titleTextField.isHidden = false
            editButton.isHidden = true
            titleLabel.isHidden = true
        } else {
            titleTextField.isHidden = true
            editButton.isHidden = false
            titleLabel.isHidden = false
        }
    }

    private func updateCurrentTitle() {
        titleLabel.text = titleTextField.text
    }
}

extension DYNavigationEditableTitle: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isEditting = false
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= Design.titleMaxCount
   }

}
