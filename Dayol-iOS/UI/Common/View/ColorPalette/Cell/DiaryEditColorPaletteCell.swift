//
//  DiaryEditColorPaletteCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit

private enum Design {
    static let cellSize = CGSize(width: 24, height: 24)
    static let radius: CGFloat = 2
    static let selectedImage = UIImage(named: "colorSelect")
}

class DiaryEditColorPaletteCell: UICollectionViewCell {
    static let size = Design.cellSize
    static let identifier = "\(DiaryEditColorPaletteCell.self)"
    
    private let selectedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Design.selectedImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            selectedImage.isHidden = !isSelected
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        initView()
    }
    
    private func initView() {
        layer.cornerRadius = Design.radius
        layer.masksToBounds = true
        contentView.addSubview(selectedImage)
        selectedImage.isHidden = true
        
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: topAnchor),
            selectedImage.leftAnchor.constraint(equalTo: leftAnchor),
            selectedImage.rightAnchor.constraint(equalTo: rightAnchor),
            selectedImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(color: PaletteColor) {
        backgroundColor = color.uiColor
    }
}
