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
    static var monthlyInfoText: String { "생성한 먼슬리 플랜으로 바로 이동할 수 있어요. 원하는 월이 없다면 속지를 추가해보세요!" }
    static var weeklyInfoText: String { "생성한 위클리 플랜으로 바로 이동할 수 있어요. 원하는 주가 없다면 속지를 추가해보세요!" }
}

final class MonthlyPaperListContentView: UIView {
    enum SelectEvent {
        case item(paper: Paper)
        case add
    }

    private let viewModel: MonthlyPaperListViewModel
    private let paperBeDisplayed: PaperType
    private let disposeBag = DisposeBag()
    private var paperModels: [Paper]?
    private var infoView: InfoView?

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

    init(diaryId: String, paperBeDisplayed: PaperType) {
        self.paperBeDisplayed = paperBeDisplayed
        self.viewModel = MonthlyPaperListViewModel(diaryId: diaryId, paperType: paperBeDisplayed)
        super.init(frame: .zero)
        setupView()
        bind()

        self.paperModels = self.viewModel.paperModels
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutCollectionView() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupView() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        self.infoView = makeInfoView()

        addSubview(containerView)

        if let infoView = self.infoView {
            containerView.addArrangedSubview(infoView)
        }
        containerView.addArrangedSubview(collectionView)

        layout.itemSize = Design.cellSize
        layout.minimumLineSpacing = Design.cellSpace
        layout.sectionInset = Design.cellInset

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MonthlyPaperListCollectionViewCell.self)
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
        infoView?.closeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.infoView?.isHidden = true
            })
            .disposed(by: disposeBag)
    }

    private func makeInfoView() -> InfoView {
        var infoText: String = ""
        switch paperBeDisplayed {
        case .monthly:
            infoText = Text.monthlyInfoText
        case .weekly:
            infoText = Text.weeklyInfoText
        default:
            break
        }
        let infoView = InfoView(text: infoText)
        infoView.translatesAutoresizingMaskIntoConstraints = false

        return infoView
    }
}

extension MonthlyPaperListContentView {
    var models: [Paper]? {
        get {
            return self.paperModels
        }
        set {
            self.paperModels = newValue
            self.collectionView.reloadData()
        }
    }
}

extension MonthlyPaperListContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (paperModels?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MonthlyPaperListCollectionViewCell.self, for: indexPath)
        if indexPath.item == 0 {
            cell.configureAddCell()
        } else if let model = paperModels?[safe: indexPath.item - 1] {
            cell.configure(model: model)
        }

        return cell
    }
}

extension MonthlyPaperListContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            didSelect.onNext(.add)
        } else if let model = paperModels?[safe: indexPath.item - 1] {
            didSelect.onNext(.item(paper: model))
        }
    }
}
