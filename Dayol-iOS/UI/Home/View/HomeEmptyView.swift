//
//  HomeBackgroundView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

private enum Design {
    enum Diary {
        // Constraint
        static let imageSize = CGSize(width: 140, height: 161)
        static let arrowWidth: CGFloat = 36.0
        static let arrowHeight: CGFloat = 79.0
        static let arrowBottomMargin: CGFloat = 48.0
        static let numberOfLines = 2
        // Text
        static let text = "다이어리가 없습니다.\n나만의 다이어리를 만들어볼까요?"
        // Image
        static let diaryImage = Assets.Image.Home.emptyDiaryIcon
        static let arrowImage = Assets.Image.Home.emptyArrow
    }

    enum Favorite {
        // Constraint
        static let imageSize = CGSize(width: 190.0, height: 161)
        static let numberOfLines = 3
        // Text
        static let text = "즐겨찾기한 메모가 없습니다.\n다이어리의 속지를 한 페이지 단위로\n즐겨찾기 할 수 있습니다."
        // Image
        static let favoriteIamge = Assets.Image.Home.emptyFavoriteIcon
    }

    enum Common {
        // Constraint
        static let stackViewSpacing: CGFloat = 18.0
        static let centerYMargin: CGFloat = 55.0
        // Font
        static let titleFont = UIFont.appleRegular(size: 15)
        // Color
        static let titleColor = UIColor(red: 153 / 255.0,
                                        green: 153 / 255.0,
                                        blue: 153 / 255.0,
                                        alpha: 1.0)
    }

    static func attributedText(text: String) -> NSAttributedString{
        return NSAttributedString.build(text: text,
                                        font: Common.titleFont,
                                        align: .center,
                                        letterSpacing: -0.28,
                                        foregroundColor: Common.titleColor)
    }
}

class HomeEmptyView: UIView {

    enum Style {
        case diary
        case favorite
    }
    private let style: Style
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
        stackView.spacing = Design.Common.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(style: Style) {
        self.style = style
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


        if style == .diary {
            setupDiaryStyle()
            setupArrowView()
        } else {
            setupFavoriteStyle()
        }
    }

    func setupDiaryStyle() {
        imageView.image = Design.Diary.diaryImage
        textLabel.numberOfLines = Design.Diary.numberOfLines
        textLabel.attributedText = Design.attributedText(text: Design.Diary.text)
    }

    func setupFavoriteStyle() {
        imageView.image = Design.Favorite.favoriteIamge
        textLabel.numberOfLines = Design.Favorite.numberOfLines
        textLabel.attributedText = Design.attributedText(text: Design.Favorite.text)
    }

    func setupArrowView() {
        let arrowView = UIImageView(frame: .zero)
        arrowView.image = Design.Diary.arrowImage
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowView)

        NSLayoutConstraint.activate([
            arrowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: Design.Diary.arrowWidth),
            arrowView.heightAnchor.constraint(equalToConstant: Design.Diary.arrowHeight),
            arrowView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Design.Diary.arrowBottomMargin)
        ])
    }

    func setupConstraints() {
        let size = (style == .diary) ? Design.Diary.imageSize : Design.Favorite.imageSize

        NSLayoutConstraint.activate([

            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                               constant: Design.Common.centerYMargin),

            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height)

        ])
    }
}
