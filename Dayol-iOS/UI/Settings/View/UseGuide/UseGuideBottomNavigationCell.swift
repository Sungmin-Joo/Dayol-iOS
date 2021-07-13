//
//  UseGuideBottomNavigationCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/07.
//

import UIKit

private enum Design {
    static let cellSize = CGSize(width: 50, height: 72)
    static let selectedImage = UIImage(named: "img_thumb_selected")
}

class UseGuideBottomNavigationCell: UICollectionViewCell {
    static let size = Design.cellSize
    static let identifier = "\(DiaryEditColorPaletteCell.self)"

    //MARK: UI Property

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Design.selectedImage
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override var isSelected: Bool {
        didSet {
            selectedImageView.isHidden = !isSelected
        }
    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Configure Cell

    func setThumbnail(scene: UseGuide.Scene) {
        let image = UIImage(named: scene.thumbnailImageName)
        imageView.image = image
    }
}

// MARK: - Private initial function

private extension UseGuideBottomNavigationCell {

    func initView() {
        contentView.addSubview(imageView)
        contentView.addSubview(selectedImageView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            selectedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
