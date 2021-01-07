//
//  DiaryPaperEmptyView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/07.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    case ipad
    case iphone
    
    static var current: Design = { isPadDevice ? .ipad : iphone }()
    
    var emptyTop: CGFloat {
        switch self {
        case .iphone:
            return 77
        case .ipad:
            if screenWidth < screenHeight {
                return 56
            } else {
                return 128
            }
        }
    }
    
    var emptyBottom: CGFloat {
        switch self {
        case .iphone:
            return 84
        case .ipad:
            if screenWidth < screenHeight {
                return 61
            } else {
                return 134
            }
        }
    }
    
    static let diaryAddImage = UIImage(named: "diaryAdd")
    static let diaryAddImageSize = CGSize(width: 40, height: 40)
    static let containerSpace: CGFloat = 25
    
    static let inputFont = UIFont.appleRegular(size: 15)
    static let inputLetterSpace: CGFloat = -0.28
    static let inputFontColor = UIColor(decimalRed: 102, green: 102, blue: 102)
    
    static let borderRatio: CGFloat = 400 / 300
    static let borderColor = UIColor(decimalRed: 151, green: 151, blue: 151).cgColor
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 6
}

private enum Text {
    static let inputText: String = "첫번째 속지를 추가해보세요!"
}

class DiaryPaperEmptyView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Design.containerSpace
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let containerLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = Design.borderColor
        layer.lineDashPattern = [4, 2]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }()
    
    private let addImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Design.diaryAddImageSize.width, height: Design.diaryAddImageSize.height))
        imageView.image = Design.diaryAddImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let inputLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Design.inputFont,
            .kern: Design.inputLetterSpace,
            .foregroundColor: Design.inputFontColor
        ]
        let attributedText = NSMutableAttributedString(string: Text.inputText, attributes: attributes)
        label.attributedText = attributedText
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setupBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    private func initView() {
        stackView.addArrangedSubview(addImageView)
        stackView.addArrangedSubview(inputLabel)
        containerView.addSubview(stackView)
        addSubview(containerView)
        
        setupConstraint()
    }
    
    private func setupBorder() {
        let path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: Design.cornerRadius)
        containerLayer.path = path.cgPath
        containerView.layer.addSublayer(containerLayer)
    }
    
    private func updateBorder() {
        let path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: Design.cornerRadius)
        containerLayer.path = path.cgPath
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: Design.borderRatio),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: Design.current.emptyTop),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.current.emptyBottom)
        ])
    }
}
