//
//  DYNavigationFunctionToolBar.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/03.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let buttonSize = CGSize(width: 40, height: 40)
    static let buttonSpace: CGFloat = 58
    static let containerLeft: CGFloat = 20.5
    static let containerRight: CGFloat = 20.5
    
    static let editImageOff = UIImage(named: "diaryEditButtonOff")
    static let editImageOn = UIImage(named: "diaryEditButtonOn")
    static let favoriteImageOff = UIImage(named: "diaryFavoriteButtonOff")
    static let favoriteImageOn = UIImage(named: "diaryFavoriteButtonOn")
    static let garbageImageOff = UIImage(named: "diaryGarbageButtonOff")
    static let garbageImageOn = UIImage(named: "diaryGarbageButtonOn")
    static let pageImage = UIImage(named: "diaryPageButton")
}

class DYNavigationFunctionToolBar: UIView {
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = Design.buttonSpace
        
        return stackView
    }()
    
    let editButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.width, height: Design.buttonSize.height))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.editImageOn, for: .normal)
        button.setImage(Design.editImageOff, for: .disabled)
        
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.width, height: Design.buttonSize.height))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.favoriteImageOn, for: .normal)
        button.setImage(Design.favoriteImageOff, for: .disabled)
        
        return button
    }()
    
    let garbageButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.width, height: Design.buttonSize.height))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.garbageImageOn, for: .normal)
        button.setImage(Design.garbageImageOff, for: .disabled)
        
        return button
    }()
    
    let pageButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.width, height: Design.buttonSize.height))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.pageImage, for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        containerView.addArrangedSubview(pageButton)
        containerView.addArrangedSubview(editButton)
        containerView.addArrangedSubview(favoriteButton)
        containerView.addArrangedSubview(garbageButton)
        addSubview(containerView)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.containerLeft),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.containerRight),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func inactivateButtons() {
        editButton.isEnabled = false
        favoriteButton.isEnabled = false
        garbageButton.isEnabled = false
    }

    func activateButtons() {
        editButton.isEnabled = true
        favoriteButton.isEnabled = true
        garbageButton.isEnabled = true
    }
}
