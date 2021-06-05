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

private enum Text {
    static var infoText: String { "생성한 먼슬리 플랜으로 바로 이동할 수 있어요. 원하는 월이 없다면 속지를 추가해보세요!" }
}

final class PaperSelectContentView: UIView {
    enum SelectEvent {
        case item(paper: DiaryInnerModel.PaperModel)
        case add
    }

    private let disposeBag = DisposeBag()
    private var paperModels: [DiaryInnerModel.PaperModel]?
    private let viewModel = PaperSelectModalViewModel()

    let didSelect = PublishSubject<SelectEvent>()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0

        return stackView
    }()

    private let infoView: InfoView = {
        let infoView = InfoView(text: Text.infoText)

        infoView.translatesAutoresizingMaskIntoConstraints = false

        return infoView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        bind()
        self.models = viewModel.paperModels
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutCollectionView() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupView() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        addSubview(containerView)
        containerView.addArrangedSubview(infoView)
        containerView.addArrangedSubview(collectionView)

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
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bind() {
        infoView.closeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.infoView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}

extension PaperSelectContentView {
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

extension PaperSelectContentView: UICollectionViewDataSource {
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

extension PaperSelectContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            didSelect.onNext(.add)
        } else if let model = paperModels?[safe: indexPath.item - 1] {
            didSelect.onNext(.item(paper: model))
        }
    }
}
