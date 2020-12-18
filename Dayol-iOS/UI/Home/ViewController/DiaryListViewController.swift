//
//  DiaryListViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/17.
//

import UIKit

private enum Design {
    // Layout
    static let iconImageTopMargin: CGFloat = 21.0
    // Image
    static let topIcon = Assets.Image.Home.topIcon
    // Color
    static let bgColor = UIColor.white
}


class DiaryListViewController: UIViewController {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Design.topIcon
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    private let emptyView: HomeEmptyView = {
        let view = HomeEmptyView(style: .diary)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var isEmpty: Bool = true {
        didSet {
            updateCurrentState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()
        updateCurrentState()
    }

    private func updateCurrentState() {
        emptyView.isHidden = !isEmpty
    }
}

// MARK: - Setup UI
extension DiaryListViewController {
    private func setupViews() {
        view.addSubview(iconImageView)
        view.addSubview(emptyView)
        view.backgroundColor = Design.bgColor
    }
}

// MARK: - Layout Constraints
extension DiaryListViewController {

    private func setupLayoutConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor,
                                               constant: Design.iconImageTopMargin),
            iconImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),

            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
