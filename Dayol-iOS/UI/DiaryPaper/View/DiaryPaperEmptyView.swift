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
    private lazy var topContraint = borderView.topAnchor.constraint(equalTo: topAnchor)
    private lazy var bottomContraint = borderView.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Design.containerSpace
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        setupBorderView()
    }
    
    private func initView() {
        containerView.addArrangedSubview(addImageView)
        containerView.addArrangedSubview(inputLabel)
        borderView.addSubview(containerView)
        addSubview(borderView)
        
        setupConstraint()
    }
    
    private func setupBorderView() {
        let dashedLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: Design.cornerRadius)
        dashedLayer.path = path.cgPath
        dashedLayer.strokeColor = Design.borderColor
        dashedLayer.lineDashPattern = [4, 2]
        dashedLayer.backgroundColor = UIColor.clear.cgColor
        dashedLayer.fillColor = UIColor.clear.cgColor
        borderView.layer.addSublayer(dashedLayer)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            topContraint,
            bottomContraint,
            containerView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            borderView.heightAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: Design.borderRatio),
            borderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension DiaryPaperEmptyView {
    func setConstraint(top: CGFloat, bottom: CGFloat) {
        topContraint.constant = top
        bottomContraint.constant = -bottom
    }
}
