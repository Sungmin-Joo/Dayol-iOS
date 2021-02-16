//
//  DeletedPageListView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/14.
//

import RxSwift
import RxCocoa

private enum Design {
    static let contentBGColor = UIColor(decimalRed: 242, green: 244, blue: 246)

    static let emptyLabelTextColor = UIColor(decimalRed: 136, green: 136, blue: 136)
    static let emptyLabelContentSpacing: CGFloat = -0.28
    static let emptyLabelFont = UIFont.appleRegular(size: 15.0)

    static let numberOfItemInRow = 2
    static let lineSpacing: CGFloat = 40.0

}

private enum Text {
    static let info = "휴지통에 보관된 메모는 삭제한 날로부터 30일 동안 보관되며, 30일 후 자동 영구삭제 됩니다."
    static let emptyLabel = "휴지통이 비어있습니다."
}

class DeletedPageListView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel = DeletedPageViewModel()
    private var shouldShowInfoLabel: Bool {
        return true
    }
    let isEmpty = BehaviorSubject<Bool>(value: true)

    //MARK: UI Property
    private let emptyContentLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(text: Text.emptyLabel,
                                                        font: Design.emptyLabelFont,
                                                        align: .center,
                                                        letterSpacing: Design.emptyLabelContentSpacing,
                                                        foregroundColor: Design.emptyLabelTextColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = DeletedPageCell.cellSize
        layout.minimumLineSpacing = Design.lineSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Design.contentBGColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private(set) lazy var infoView: InfoView = {
        let view = InfoView(text: Text.info)
        view.closeButton.rx.tap
            .bind { [weak self] in
                self?.contentStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            .disposed(by: disposeBag)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionView(to: frame.size)
    }

    func updateCollectionView(to size: CGSize) {
        guard
            viewModel.diaryList.count != .zero,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }

        let insets = calcCollectionViewInset(width: size.width)
        layout.sectionInset = insets
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func calcCollectionViewInset(width: CGFloat) -> UIEdgeInsets {
        let totalItemWidth = CGFloat(Design.numberOfItemInRow) * DeletedPageCell.cellSize.width
        let totalMargin = width - totalItemWidth
        let sideMargin = totalMargin / 3.0

        return UIEdgeInsets(top: 24, left: sideMargin, bottom: 24, right: sideMargin)
    }

    func didTapDeleteAllButton() {
        viewModel.deleteAll()
    }

}

// MARK: - Private initial function

private extension DeletedPageListView {

    func initView() {
        backgroundColor = Design.contentBGColor
        addSubview(emptyContentLabel)
        addSubview(contentStackView)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DeletedPageCell.self, forCellWithReuseIdentifier: DeletedPageCell.identifier)

        if shouldShowInfoLabel {
            contentStackView.addArrangedSubview(infoView)
        }
        contentStackView.addArrangedSubview(collectionView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            emptyContentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyContentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func bindEvent() {
        viewModel.deletedPageEvent
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .fetch(let isEmpty):
                    guard isEmpty == false else {
                        self?.showEmptyLabel()
                        return
                    }
                    self?.hideEmptyLabel()
                    self?.collectionView.reloadData()
                case .deleteAll:
                    self?.showEmptyLabel()
                }
            })
            .disposed(by: disposeBag)
    }

    func showEmptyLabel() {
        collectionView.alpha = 0
        isEmpty.onNext(true)
    }

    func hideEmptyLabel() {
        collectionView.alpha = 1.0
        isEmpty.onNext(false)
    }

}

// MARK: - UICollectionViewDataSource

extension DeletedPageListView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.diaryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeletedPageCell.identifier, for: indexPath)

        if let deletedPageCell = cell as? DeletedPageCell {
            deletedPageCell.viewModel = viewModel.diaryList[safe: indexPath.row]
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension DeletedPageListView: UICollectionViewDelegate {

}
