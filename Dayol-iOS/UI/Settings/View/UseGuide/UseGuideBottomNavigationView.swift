//
//  UseGuideBottomNavigationView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/07.
//

import UIKit

private enum Design {
    static let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    static let itemSpacing: CGFloat = 13.0
    static let backgroundColor = UIColor(decimalRed: 246, green: 247, blue: 248)
}

class UseGuideBottomNavigationView: UIView {

    private let scene: [UseGuide.Scene] = UseGuide.Scene.allCases
    weak var delegate: UseGuideSceneChangeDelegate?

    // MARK: UI Property

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Design.sectionInset
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Design.itemSpacing
        layout.minimumInteritemSpacing = Design.itemSpacing
        layout.itemSize = UseGuideBottomNavigationCell.size
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = Design.backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func selectItem(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

}

// MARK: - Private initial function

private extension UseGuideBottomNavigationView {

    func initView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UseGuideBottomNavigationCell.self,
            forCellWithReuseIdentifier: UseGuideBottomNavigationCell.identifier
        )

        addSubview(collectionView)
        backgroundColor = collectionView.backgroundColor
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

// MARK: - UICollectionViewDelegate

extension UseGuideBottomNavigationView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didChangeScene(index: indexPath.row, sender: self)
    }

}

// MARK: - UICollectionViewDataSource

extension UseGuideBottomNavigationView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scene.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UseGuideBottomNavigationCell.identifier, for: indexPath)
        
        guard
            let navigationCell = cell as? UseGuideBottomNavigationCell,
            let scene = scene[safe: indexPath.row]
        else {
            return cell
        }

        navigationCell.setThumbnail(scene: scene)

        return navigationCell
    }

}
