//
//  DiaryEditColorPaletteView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let paletteBackgroundColor = UIColor(decimalRed: 247, green: 247, blue: 247)
    static let cellSpace: CGFloat = 11
}

class DiaryEditColorPaletteView: UIView {
    private let colors = DiaryCoverColor.allCases
    private var collectionViewWidthForIpad: CGFloat {
        let inset: CGFloat = 16
        let cellWidth: CGFloat = DiaryEditColorPaletteCell.size.width
        let cellCount: CGFloat = CGFloat(colors.count)
        
        let totalCellWidth = cellWidth * cellCount
        let totalSpace = Design.cellSpace * (cellCount-1)
        
        return (inset * 2) + totalSpace + totalCellWidth
    }
    
    let changedColor = PublishSubject<DiaryCoverColor>()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = Design.paletteBackgroundColor
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DiaryEditColorPaletteCell.self, forCellWithReuseIdentifier: DiaryEditColorPaletteCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentMode = .center
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.scrollDirection = .horizontal
            layout.itemSize = DiaryEditColorPaletteCell.size
            layout.minimumInteritemSpacing = Design.cellSpace
            layout.minimumLineSpacing = Design.cellSpace
        }
        
        addSubview(collectionView)
        
        setConstraint()
    }
    
    private func setConstraint() {
        if isPadDevice {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                collectionView.widthAnchor.constraint(equalToConstant: collectionViewWidthForIpad),
                collectionView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                collectionView.leftAnchor.constraint(equalTo: leftAnchor),
                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            ])
        }
    }
}

extension DiaryEditColorPaletteView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryEditColorPaletteCell.identifier, for: indexPath) as? DiaryEditColorPaletteCell,
              let color = colors[safe: indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.configure(color: color)
        
        return cell
    }
}

extension DiaryEditColorPaletteView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let color = colors[safe: indexPath.item] else { return }
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        changedColor.onNext(color)
    }
}