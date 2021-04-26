//
//  DYFloatingView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/04/20.
//

import RxSwift
import RxCocoa

private enum Design {
    static let buttonTitleFont = UIFont.appleBold(size: 15)
    static let buttonTitleLetterSpacing: CGFloat = -0.28
    static let buttonTitleColor: UIColor = .white
    static let buttonAddImage = UIImage(named: "addPaper")
    static let buttonDeleteImage = UIImage(named: "deletePaper")
    static let buttonHeight: CGFloat = 40
    static let buttonSpacing: CGFloat = 20
    
    static let buttonContainerLeading: CGFloat = 20
    static let buttonContainerTop: CGFloat = 10
    static let buttonContainerTrailing: CGFloat = 20
    static let buttonContainerBottom: CGFloat = 6
    
    static let descFont = UIFont.appleRegular(size: 12)
    static let descLetterSpacing: CGFloat = -22
    static let descColor: UIColor = UIColor(decimalRed: 153, green: 153, blue: 153)
    static let descBottom: CGFloat = 9
    
    static let separatorColor = UIColor(decimalRed: 95, green: 95, blue: 95)
    static let separatorSize = CGSize(width: 1, height: 20)
    
    static let backgroundColor = UIColor.black.withAlphaComponent(0.9)
    static let cornerRadius: CGFloat = 8.0
}

private enum Text: String {
    case addPaper = "DYFloatingView.addPaper"
    case deletePaper = "DYFloaingView.deletePaper"
    case desc = "DYFloatingView.desc"
    
    var localized: String {
        return self.rawValue.localized
    }
}

final class DYFloatingView: UIView {

    // MARK: - UI Components
    
    private let buttonContrainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Design.buttonSpacing
        stackView.distribution = .equalCentering
        
        return stackView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.buttonAddImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.buttonAddImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.separatorColor
        
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupTexts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    
    private func setupViews() {
        buttonContrainer.addArrangedSubview(addButton)
        buttonContrainer.addArrangedSubview(separator)
        buttonContrainer.addArrangedSubview(deleteButton)
        addSubview(buttonContrainer)
        addSubview(descLabel)

        backgroundColor = Design.backgroundColor
        layer.cornerRadius = Design.cornerRadius
        layer.masksToBounds = true
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonContrainer.topAnchor.constraint(equalTo: topAnchor, constant: Design.buttonContainerTop),
            buttonContrainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.buttonContainerLeading),
            buttonContrainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Design.buttonContainerTrailing),
            buttonContrainer.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: Design.buttonContainerBottom),
            
            descLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.descBottom),
            
            separator.widthAnchor.constraint(equalToConstant: Design.separatorSize.width),
            separator.heightAnchor.constraint(equalToConstant: Design.separatorSize.height)
        ])
    }
    
    private func setupTexts() {
        addButton.titleLabel?.attributedText = NSAttributedString.build(text: Text.addPaper.localized,
                                                                        font: Design.buttonTitleFont,
                                                                        align: .natural,
                                                                        letterSpacing: Design.buttonTitleLetterSpacing,
                                                                        foregroundColor: Design.buttonTitleColor)
        deleteButton.titleLabel?.attributedText = NSAttributedString.build(text: Text.deletePaper.localized,
                                                                           font: Design.buttonTitleFont,
                                                                           align: .natural,
                                                                           letterSpacing: Design.buttonTitleLetterSpacing,
                                                                           foregroundColor: Design.buttonTitleColor)
        descLabel.attributedText = NSAttributedString.build(text: Text.desc.localized,
                                                            font: Design.descFont,
                                                            align: .natural,
                                                            letterSpacing: Design.descLetterSpacing,
                                                            foregroundColor: Design.descColor)
    }
}
