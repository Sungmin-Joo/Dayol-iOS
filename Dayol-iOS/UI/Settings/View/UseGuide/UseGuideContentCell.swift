//
//  UseGuideContentCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/08.
//

import UIKit
import RxSwift

private enum Design {
    static let stackViewSpacing: CGFloat = 30.0
    static let scrollViewTopInset: CGFloat = 30.0
    
    static let switchViewStandardSize = CGSize(width: 335.0, height: 44.0)
    static let switchViewHeightRatio: CGFloat = switchViewStandardSize.height / switchViewStandardSize.width
    static let switchViewSideMargin: CGFloat = 20
}


class UseGuideContentCell: UICollectionViewCell {
    typealias CellModel = (scene: UseGuide.Scene, style: UseGuide.Style)
    static let identifier = "\(UseGuideContentCell.self)"
    
    private let disposeBag = DisposeBag()
    var didChangeStyle: ((UseGuide.Style) -> Void)?
    var cellModel: CellModel? {
        didSet { configureCellModel() }
    }
    
    // MARK: UI Property
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = UIEdgeInsets(
            top: Design.scrollViewTopInset,
            left: 0,
            bottom: 0,
            right: 0
        )
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Design.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let guideImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let switchView: UseGuideSwitchView = {
        let switchView = UseGuideSwitchView(style: .vertical)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    private var switchViewWidthConstraint = NSLayoutConstraint()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switchViewWidthConstraint.constant = bounds.width - (2 * Design.switchViewSideMargin)
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setupConstraints()
        bindEvent()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Configure Cell
    
    private func configureCellModel() {
        guard let cellModel = cellModel else { return }
        if cellModel.scene == .about {
            switchView.isHidden = true
            titleLabel.isHidden = true
        } else {
            switchView.isHidden = false
            titleLabel.isHidden = false
            titleLabel.attributedText = NSAttributedString.build(
                text: cellModel.scene.title,
                font: .boldSystemFont(ofSize: 20),
                align: .center,
                letterSpacing: -0.37,
                foregroundColor: .gray900
            )
            switchView.style = cellModel.style
        }
        
        let imageName = cellModel.scene.contentImageName(style: cellModel.style)
        var image = UIImage(namedByLanguage: imageName)
        
        if contentView.frame.width < 375 {
            image = image?.resizeToRatio(width: contentView.frame.width)
        }
        guideImageView.image = image
        
    }
}

// MARK: - Private initial function

private extension UseGuideContentCell {
    
    private func initView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(switchView)
        stackView.addArrangedSubview(guideImageView)
        scrollView.addSubview(stackView)
        contentView.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        switchViewWidthConstraint = switchView.widthAnchor.constraint(equalToConstant: Design.switchViewStandardSize.width)
        
        let frameLayoutGuide = scrollView.frameLayoutGuide
        let contentsLayoutGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            frameLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            frameLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frameLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentsLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentsLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentsLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentsLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            guideImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            switchViewWidthConstraint,
            switchView.heightAnchor.constraint(
                equalTo: switchView.widthAnchor,
                multiplier: Design.switchViewHeightRatio
            )
        ])
    }
    
    private func bindEvent() {
        switchView.styleSubject
            .subscribe(onNext: { [weak self] style in
                self?.cellModel?.style = style
                self?.didChangeStyle?(style)
            })
            .disposed(by: disposeBag)
    }
}
