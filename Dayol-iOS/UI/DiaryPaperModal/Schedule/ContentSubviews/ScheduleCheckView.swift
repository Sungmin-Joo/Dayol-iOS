//
//  ScheduleCheckView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/10.
//

import UIKit

private enum Design {
    enum Image {
        static let uncheck = UIImage(named: "paper_add_btn_off")
        static let check = UIImage(named: "paper_add_btn_on")
    }

    enum Label {
        static let titleTextColor = UIColor.gray900
        static let titleLetterSpace: CGFloat = -0.28
        static let titleTextFont = UIFont.appleBold(size: 15)

        static let descTextColor = UIColor.gray700
        static let descLetterSpace: CGFloat = -0.24
        static let descTextFont = UIFont.appleRegular(size: 13)
    }

    enum Size {
        static let imageView = CGSize(width: 24, height: 24)
    }

    enum Margin {
        static let imageLabelSpace: CGFloat = 10
        static let titleDescSpace: CGFloat = 1
    }
}

private enum Text: String {
    case title = "%@ Plan에 자동 등록"
    case desc = "%@ Plan 속지가 없는 경우, 자동 생성 후 등록합니다."
}

final class ScheduleCheckView: UIView {
    enum CheckType {
        case weekly
        case monthly

        var stringValue: String {
            switch self {
            case .monthly: return "Monthly"
            case .weekly: return "Weekly"
            }
        }
    }

    private var isCheck = true

    //MARK: - UI Component

    private let labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = Design.Size.imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Design.Image.check
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    // MARK: -Init

    init(checkType: CheckType) {
        super.init(frame: .zero)
        setupViews()
        setupLabel(checkType: checkType)
        setupConstraints()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(checkImageView)
        addSubview(labelContainerView)
        labelContainerView.addSubview(titleLabel)
        labelContainerView.addSubview(descLabel)
    }

    private func setupLabel(checkType: CheckType) {
        let titleText = String(format: Text.title.rawValue, checkType.stringValue)
        let descText = String(format: Text.desc.rawValue, checkType.stringValue)
        titleLabel.attributedText = NSAttributedString.build(text: titleText,
                                                             font: Design.Label.titleTextFont,
                                                             align: .left,
                                                             letterSpacing: Design.Label.titleLetterSpace,
                                                             foregroundColor: Design.Label.titleTextColor)
        descLabel.attributedText = NSAttributedString.build(text: descText,
                                                            font: Design.Label.descTextFont,
                                                            align: .left,
                                                            letterSpacing: Design.Label.descLetterSpace,
                                                            foregroundColor: Design.Label.descTextColor)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            labelContainerView.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: Design.Margin.imageLabelSpace),
            labelContainerView.topAnchor.constraint(equalTo: topAnchor),
            labelContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Design.Margin.titleDescSpace),
            descLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            descLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedImageView(_:)))
        checkImageView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func didTappedImageView(_ sender: Any) {
        if isCheck == true {
            isCheck = false
            UIView.transition(with: checkImageView, duration: 0.2, options: .transitionCrossDissolve) {
                self.checkImageView.image = Design.Image.uncheck
            }
        } else {
            isCheck = true
            UIView.transition(with: checkImageView, duration: 0.2, options: .transitionCrossDissolve) {
                self.checkImageView.image = Design.Image.check
            }
        }
    }
}
