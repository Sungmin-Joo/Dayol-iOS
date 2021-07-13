//
//  UseGuideView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/07.
//

import UIKit

private enum Design {
    static let bottomViewHeight: CGFloat = 112
}

protocol UseGuideSceneChangeDelegate: AnyObject {
    func didChangeScene(index: Int, sender: UIView)
}

class UseGuideView: UIView {

    // MARK: UI Property
    private let contentView = UseGuideContentView()
    private let bottomView = UseGuideBottomNavigationView()

    init() {
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Private initial function

private extension UseGuideView {

    func initView() {
        addSubview(contentView)
        addSubview(bottomView)

        backgroundColor = bottomView.backgroundColor

        contentView.delegate = self
        bottomView.delegate = self

        contentView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        bottomView.selectItem(index: 0)
        contentView.moveScene(index: 0)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),

            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: Design.bottomViewHeight)
        ])
    }

}

extension UseGuideView: UseGuideSceneChangeDelegate {

    func didChangeScene(index: Int, sender: UIView) {
        if sender is UseGuideContentView {
            bottomView.selectItem(index: index)
        } else {
            contentView.moveScene(index: index)
        }
    }

}
