//
//  UseGuideContentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/07.
//

import UIKit

private enum Design {
    static let leftArrow = UIImage(named: "use_guid_arrow_left")
    static let rightArrow = UIImage(named: "use_guid_arrow_right")
    
    static let arrowMargin: CGFloat = 14.0
}

class UseGuideContentView: UIView {
    
    private let scene: [UseGuide.Scene] = UseGuide.Scene.allCases
    private var timer: Timer?
    lazy var cellModels: [UseGuideContentCell.CellModel] = {
        return scene.map { ($0, .vertical) }
    }()
    
    weak var delegate: UseGuideSceneChangeDelegate?
    
    // MARK: UI Property
    
    private let leftArrow: UIImageView = {
        let imageView = UIImageView(image: Design.leftArrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rightArrow: UIImageView = {
        let imageView = UIImageView(image: Design.rightArrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func moveScene(index: Int) {
        showArrow()
        let offsetX: CGFloat = CGFloat(index) * collectionView.frame.width
        let newOffset = CGPoint(x: offsetX, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(newOffset, animated: false)
    }
    
}

// MARK: - Private initial function

private extension UseGuideContentView {
    
    func initView() {
        leftArrow.alpha = 0
        rightArrow.alpha = 0
        addSubview(collectionView)
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        collectionView.register(
            UseGuideContentCell.self,
            forCellWithReuseIdentifier: UseGuideContentCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftArrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftArrow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.arrowMargin),
            
            rightArrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Design.arrowMargin),
        ])
    }
    
    @objc func applicationDidEnterBackground() {
        guard timer != nil else { return }
        removeTimer()
        hideArrow()
    }
    
}

// MARK: - Arrow

private extension UseGuideContentView {
    
    func showArrow() {
        removeTimer()
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.leftArrow.alpha = 1.0
            self.rightArrow.alpha = 1.0
        } completion: { _ in
            self.timer = .scheduledTimer(
                withTimeInterval: 3.0,
                repeats: false
            ) { [weak self] _ in
                self?.hideArrow()
            }
        }
        
    }
    
    func hideArrow() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.leftArrow.alpha = 0
            self.rightArrow.alpha = 0
        }
    }
    
    func removeTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        timer = nil
    }
    
}

// MARK: - UICollectionViewDelegate

extension UseGuideContentView: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showArrow()
        
        let index: Int = Int(floor(targetContentOffset.pointee.x / scrollView.frame.width))
        delegate?.didChangeScene(index: index, sender: self)
    }
    
}

// MARK: - UICollectionViewDataSource

extension UseGuideContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scene.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UseGuideContentCell.identifier, for: indexPath)
        
        guard
            let contentCell = cell as? UseGuideContentCell,
            var cellModel = cellModels[safe: indexPath.row]
        else {
            return cell
        }
        contentCell.cellModel = cellModel
        contentCell.didChangeStyle = { [weak self] style in
            cellModel.style = style
            self?.cellModels[indexPath.row] = cellModel
        }
        return contentCell
    }
    
}

// MARK: - CollectionView FlowLayout

extension UseGuideContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }
}
