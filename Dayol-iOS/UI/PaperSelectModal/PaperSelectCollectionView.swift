//
//  PaperSelectCollectionView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import UIKit
import RxSwift

private enum Design {
    static let cellSize = CGSize(width: 90, height: 159)
    static let cellSpace: CGFloat = 28
    static let cellInset: UIEdgeInsets = .init(top: 34, left: 25, bottom: 34, right: 25)
}

final class PaperSelectCollectionView: UIView {
    enum SelectEvent {
        case item(paper: DiaryInnerModel.PaperModel)
        case add
    }

    private var paperModels: [DiaryInnerModel.PaperModel]?

    let didSelect = PublishSubject<SelectEvent>()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        addSubview(collectionView)

        layout.itemSize = Design.cellSize
        layout.minimumLineSpacing = Design.cellSpace
        layout.sectionInset = Design.cellInset

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaperSelectCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.gray100

        setupConstraint()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension PaperSelectCollectionView {
    var models: [DiaryInnerModel.PaperModel]? {
        get {
            return self.paperModels
        }
        set {
            self.paperModels = newValue
            self.collectionView.reloadData()
        }
    }
}

extension PaperSelectCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (paperModels?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PaperSelectCollectionViewCell.self, for: indexPath)
        if indexPath.item == 0 {
            cell.configureAddCell()
        } else if let model = paperModels?[safe: indexPath.item - 1] {
            cell.configure(model: model)
        }

        return cell
    }
}

extension PaperSelectCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            didSelect.onNext(.add)
        } else if let model = paperModels?[safe: indexPath.item - 1] {
            didSelect.onNext(.item(paper: model))
        }
    }
}
