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
            changeEditMode(isEditting: isEditting)
        }
    }
    
    let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.editButtonImage, for: .normal)
        
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isHidden = true
        textView.backgroundColor = Design.titleBackgroundColor
        textView.layer.borderWidth = Design.titleBorderWidth
        textView.layer.borderColor = Design.titleBorderColor
        textView.layer.cornerRadius = Design.titleRadius
        textView.layer.masksToBounds = true
        
        return textView
    }()
    
    override init(text: String) {
        super.init(text: text)
        textView.attributedText = attributedText(text: text)
        horizontalStack.addArrangedSubview(editButton)
        horizontalStack.addArrangedSubview(textView)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        let textViewHeight = textView.heightAnchor.constraint(equalToConstant: Design.titleSize.height)
        textViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: Design.editButtonSize.width),
            editButton.heightAnchor.constraint(equalToConstant: Design.editButtonSize.height),
            
            textView.widthAnchor.constraint(equalToConstant: Design.titleSize.width),
            textViewHeight
        ])
    }
    
    private func changeEditMode(isEditting: Bool) {
        textView.isHidden = !isEditting
        editButton.isHidden = isEditting
        titleLabel.isHidden = isEditting
    }
}
