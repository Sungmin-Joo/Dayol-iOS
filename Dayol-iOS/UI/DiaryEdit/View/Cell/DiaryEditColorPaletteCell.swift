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
}

class DiaryEditColorPaletteCell: UICollectionViewCell {
    static let size = Design.cellSize
    static let identifier = "\(DiaryEditColorPaletteCell.self)"
    
    init(color: DiaryCoverColor) {
        super.init(frame: .zero)
        initView()
        backgroundColor = color.coverColor
    }
    
    private override init(frame: CGRect) {
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
    }
    
    func configure(color: DiaryCoverColor) {
        backgroundColor = color.coverColor
    }
}
