//
//  DiaryListViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/17.
//

import UIKit
import RxSwift

private enum Design {
    static let topIcon = Assets.Image.Home.topIcon

    static let bgColor = UIColor.white

    static var collectionViewHeight: CGFloat {
        let defaultHeight: CGFloat = 432.0

        if UIScreen.main.bounds.size.height <= 667 {
            return defaultHeight * 0.7
        }

        return defaultHeight
    }
    static var itemSpacing: CGFloat {
        guard isPadDevice else {
            return 30.0
        }
        return 60.0
    }
    static func getItemSize(isEditMode: Bool) -> CGSize {
        return isEditMode ? DiaryListCell.Size.edit : DiaryListCell.Size.normal
    }
}

class DiaryListViewController: UIViewController {

    let viewModel = DiaryListViewModel()
    let disposeBag = DisposeBag()

    var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let insets = calcCollectionViewInset(width: view.bounds.width)
        layout.sectionInset = insets
        layout.scrollDirection = .horizontal
        layout.itemSize = Design.getItemSize(isEditMode: isEditMode)
        layout.minimumInteritemSpacing = Design.itemSpacing
        layout.minimumLineSpacing = Design.itemSpacing
        return layout
    }
    var isEditMode = false
    var canStartInteractiveMovement = false
    var hasReorder = false
    var currentIndex = 0
    var currentEditIndex: IndexPath?

    // MARK: - UI

    let iconButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.topIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    let emptyView: HomeEmptyView = {
        let view = HomeEmptyView(style: .diary)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()
        bind()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard
            viewModel.diaryList.count != 0,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }

        coordinator.animate { _ in
            let insets = self.calcCollectionViewInset(width: size.width)
            layout.sectionInset = insets
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.moveToIndex(self.currentIndex)
        }

    }

}

// MARK: - Setup UI

extension DiaryListViewController {

    private func setupViews() {
        setupCollectionView()

        view.addSubview(iconButton)
        view.addSubview(emptyView)
        view.addSubview(collectionView)
        view.backgroundColor = Design.bgColor
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DiaryListCell.self, forCellWithReuseIdentifier: DiaryListCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false

        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.addTarget(self,
                                             action: #selector(didRecongizeLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        collectionView.collectionViewLayout = collectionViewFlowLayout
    }

    private func calcCollectionViewInset(width: CGFloat) -> UIEdgeInsets {
        let itemWidth = Design.getItemSize(isEditMode: isEditMode).width
        let horizontalInset = width / 2 - itemWidth / 2

        return UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
}

// MARK: - Layout Constraints

extension DiaryListViewController {

    private func setupLayoutConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            iconButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            iconButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Design.collectionViewHeight),

            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
