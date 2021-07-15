//
//  PaperTextCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/15.
//

import UIKit

private enum Design {
    static let textInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    static let borderColor: UIColor = .gray500
    static let borderWidth: CGFloat = 0.2
}

final class PaperTextCell: UICollectionViewCell {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.contentInset = Design.textInset

        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initView()
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        textView.text = ""
    }

    private func initView() {
        contentView.addSubview(textView)

        contentView.layer.borderWidth = Design.borderWidth
        contentView.layer.borderColor = Design.borderColor.cgColor

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(text: String) {
        textView.text = text
    }

    func estimatedSize(width: CGFloat, text: String) -> CGSize {
        textView.widthAnchor.constraint(equalToConstant: width).isActive = true
        configure(text: text)
        layoutIfNeeded()
        let estimatedSize = systemLayoutSizeFitting(CGSize(width: width, height: 300))
        return estimatedSize
    }
}
