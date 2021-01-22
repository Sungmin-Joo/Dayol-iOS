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
    enum IPadOrientation {
        case landscape
        case portrait
    }
    
    case ipad
    case iphone
    
    static var current: Design = { isPadDevice ? .ipad : iphone }()
    
    static func emptyTop(orientation: IPadOrientation) -> CGFloat {
        switch current {
        case .iphone:
            return 77
        case .ipad:
            if orientation == .portrait {
                return 56
            } else {
                return 128
            }
        }
    }
    
    static func emptyBottom(orientation: IPadOrientation) -> CGFloat {
        switch current {
        case .iphone:
            return 84
        case .ipad:
            if orientation == .portrait {
                return 61
            } else {
                return 134
            }
        }
    }
    
    static let emptyWidthForIPhone: CGFloat = 300
    static let emptyHeightForIPhone: CGFloat = 400
    
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
    private var topContraint = NSLayoutConstraint()
    private var bottomContraint = NSLayoutConstraint()
    private var iPadOrientation: Design.IPadOrientation {
        if self.frame.size.width < self.frame.size.height {
            return .portrait
        } else {
            return .landscape
        }
    }
    
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
        super.draw(rect)
        setupLayer()
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
    
    private func setupConstraint() {
        topContraint = containerView.topAnchor.constraint(equalTo: topAnchor, constant: Design.emptyTop(orientation: iPadOrientation))
        bottomContraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.emptyBottom(orientation: iPadOrientation))
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        if isPadDevice == false {
            NSLayoutConstraint.activate([
                containerView.widthAnchor.constraint(equalToConstant: Design.emptyWidthForIPhone),
                containerView.heightAnchor.constraint(equalToConstant: Design.emptyHeightForIPhone),
                containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                topContraint,
                bottomContraint,
                containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: Design.borderRatio),
                containerView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
    
    private func setupLayer() {
        let path = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: Design.cornerRadius)
        self.containerLayer.path = path.cgPath
        containerView.layer.addSublayer(containerLayer)
    }
    
    private func updateBorder() {
        DispatchQueue.main.async {
            self.topContraint.constant = Design.emptyTop(orientation: self.iPadOrientation)
            self.bottomContraint.constant = -Design.emptyBottom(orientation: self.iPadOrientation)
            
            let path = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: Design.cornerRadius)
            self.containerLayer.path = path.cgPath
        }
    }
}
