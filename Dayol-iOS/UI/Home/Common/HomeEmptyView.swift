//
//  HomeBackgroundView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

private enum Design {
    enum Style {
        case diary,favorite

        var imageSize: CGSize {
            switch self {
            case .diary: return CGSize(width: 140, height: 161)
            case .favorite: return CGSize(width: 190.0, height: 161)
            }
        }

        var numberOfLines: Int {
            switch self {
            case .diary: return 2
            case .favorite: return 3
            }
        }

        var text: String {
            switch self {
            case .diary: return "다이어리가 없습니다.\n나만의 다이어리를 만들어볼까요?"
            case .favorite: return "즐겨찾기한 메모가 없습니다.\n다이어리의 속지를 한 페이지 단위로\n즐겨찾기 할 수 있습니다."
            }
        }

        var centerImage: UIImage? {
            switch self {
            case .diary: return Assets.Image.Home.emptyDiaryIcon
            case .favorite: return Assets.Image.Home.emptyFavoriteIcon
            }
        }
    }

    static let arrowWidth: CGFloat = 36.0
    static let arrowHeight: CGFloat = 79.0
    static let arrowBottomMargin: CGFloat = 106.0
    static let arrowImage = Assets.Image.Home.emptyArrow

    static let stackViewSpacing: CGFloat = 18.0
    static let titleFont = UIFont.appleRegular(size: 15)
    static let titleColor = UIColor(red: 153 / 255.0,
                                    green: 153 / 255.0,
                                    blue: 153 / 255.0,
                                    alpha: 1.0)

    static func attributedText(text: String) -> NSAttributedString{
        return NSAttributedString.build(text: text,
                                        font: titleFont,
                                        align: .center,
                                        letterSpacing: -0.28,
                                        foregroundColor: titleColor)
    }
}

class HomeEmptyView: UIView {

    enum Style {
        case diary
        case favorite
    }
    private let style: Style
    private let styleDesign: Design.Style
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = Design.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(style: Style) {
        self.style = style
        self.styleDesign = (style == .diary) ? .diary : .favorite
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

private extension HomeEmptyView {

    func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)

        setupStyle()
    }

    func setupStyle() {
        imageView.image = styleDesign.centerImage
        textLabel.numberOfLines = styleDesign.numberOfLines
        textLabel.attributedText = Design.attributedText(text: styleDesign.text)

        if style == .diary {
            setupArrowView()
        }
    }

    func setupArrowView() {
        let arrowView = UIImageView(frame: .zero)
        arrowView.image = Design.arrowImage
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowView)

        NSLayoutConstraint.activate([
            arrowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: Design.arrowWidth),
            arrowView.heightAnchor.constraint(equalToConstant: Design.arrowHeight),
            arrowView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Design.arrowBottomMargin)
        ])
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.widthAnchor.constraint(equalToConstant: styleDesign.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: styleDesign.imageSize.height)

        ])
    }
}
