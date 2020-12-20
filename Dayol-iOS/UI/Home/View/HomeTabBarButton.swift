//
//  HomeTabBarButton.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/17.
//

import RxSwift

class HomeTabBarButton: UIButton {

    enum Style {
        case diary
        case favorite
    }

    let style: HomeTabBarButton.Style
    private(set) var selectedImage: UIImage?
    private(set) var normalImage: UIImage?
    private(set) var normalTitle: NSAttributedString?
    private(set) var selectedTitle: NSAttributedString?

    override var isSelected: Bool {
        didSet {
            updateButtonState()
        }
    }

    init(style: HomeTabBarButton.Style) {
        self.style = style
        super.init(frame: .zero)
        setupButtonStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateButtonState() {
        let image = isSelected ? selectedImage : normalImage
        let title = isSelected ? selectedTitle : normalTitle
        let isUserInteractionEnable = (isSelected == false)

        setImage(image, for: .normal)
        setAttributedTitle(title, for: .normal)
        isUserInteractionEnabled = isUserInteractionEnable
    }

}

extension HomeTabBarButton {

    private func setupButtonStyle() {
        guard style == .diary else {
            setupFavoriteButton()
            return
        }
        setupDiaryButton()
    }

    private func setupDiaryButton() {
        normalImage = Design.diaryNormal
        selectedImage = Design.diarySelected
        normalTitle = Design.buttonTitle(text: Design.diaryText, false)
        selectedTitle = Design.buttonTitle(text: Design.diaryText, true)
    }

    private func setupFavoriteButton() {
        normalImage = Design.favoriteNormal
        selectedImage = Design.favoriteSelected
        normalTitle = Design.buttonTitle(text: Design.favoriteText, false)
        selectedTitle = Design.buttonTitle(text: Design.favoriteText, true)
    }

}

private enum Design {
    // Text
    static let diaryText = "다이어리"
    static let favoriteText = "즐겨찾기"

    // Attributed Text
    static let buttonParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        return paragraphStyle
    }()
    static let buttonTitleAttributes: [NSAttributedString.Key: Any] = {
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: buttonParagraphStyle,
            .font: buttonTitleFont,
            .kern: -0.3
        ]
        return attributes
    }()
    static func buttonTitle(text: String, _ isSelected: Bool) -> NSAttributedString {
        let fgColor = isSelected ? buttonSelectedFGColor : buttonDeselectedFGColor
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: buttonTitleAttributes)
        attributedText.addAttribute(.foregroundColor,
                                    value: fgColor,
                                    range: NSRange(location: 0, length: text.count))

        return attributedText
    }
    // Font
    static let buttonTitleFont = UIFont.appleBold(size: 16.0)
    // Image
    static let diaryNormal = Assets.Image.Home.TabBarDiary.normal
    static let diarySelected = Assets.Image.Home.TabBarDiary.selected
    static let favoriteNormal = Assets.Image.Home.TabBarFavorite.normal
    static let favoriteSelected = Assets.Image.Home.TabBarFavorite.selected
    // Color
    static let buttonSelectedFGColor = UIColor.black
    static let buttonDeselectedFGColor = UIColor.black.withAlphaComponent(0.3)
}
