//
//  PaperTextableCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/15.
//

import UIKit

private enum Design {
    static let textInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: -5, right: -5)
    static let borderColor: UIColor = .gray500
    static let borderWidth: CGFloat = 0.2
}

final class PaperTextableCell: UICollectionViewCell {
    static func estimatedSize(width: CGFloat, text: String) -> CGSize {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        textView.text = text
        textView.sizeToFit()

        return textView.frame.size
    }

    private(set) var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false

        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
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

    private func setupViews() {
        contentView.addSubview(textView)

        contentView.layer.borderWidth = Design.borderWidth
        contentView.layer.borderColor = Design.borderColor.cgColor
    }

    func configure(text: String) {
        textView.text = text
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.textInset.top),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.textInset.left),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Design.textInset.right),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Design.textInset.bottom)
        ])
    }
}
