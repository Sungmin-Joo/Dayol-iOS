//
//  HomeTabBarView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import RxCocoa
import RxSwift

class HomeTabBarView: UIView {

    enum TabType {
        case diary
        case favorite
    }

    enum EventType {
        case showList(tab: TabType)
        case add
    }

    let buttonEvent = BehaviorSubject<HomeTabBarView.EventType>(value: .showList(tab: .diary))
    let disposeBag = DisposeBag()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.plusButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let diaryButton = HomeTabBarButton(style: .diary)
    private let favoriteButton = HomeTabBarButton(style: .favorite)
    private(set) var currentTabMode: TabType {
        didSet {
            updateTabBarState()
        }
    }

    init(mode: TabType) {
        self.currentTabMode = mode
        super.init(frame: .zero)
        setupViews()
        setupContentsLayout()
        bindEvent()
        updateTabBarState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Event
extension HomeTabBarView {
    private func bindEvent() {
        plusButton.rx.tap.bind { [weak self] in
            self?.buttonEvent.onNext(.add)
        }
        .disposed(by: disposeBag)

        diaryButton.rx.tap.bind { [weak self] in
            self?.currentTabMode = .diary
            self?.buttonEvent.onNext(.showList(tab: .diary))
        }
        .disposed(by: disposeBag)

        favoriteButton.rx.tap.bind { [weak self] in
            self?.currentTabMode = .favorite
            self?.buttonEvent.onNext(.showList(tab: .favorite))
        }
        .disposed(by: disposeBag)
    }

    private func updateTabBarState() {
        switch currentTabMode {
        case .diary:
            diaryButton.isSelected = true
            favoriteButton.isSelected = false
        case .favorite:
            diaryButton.isSelected = false
            favoriteButton.isSelected = true
        }
    }

}

// MARK: - Setup
extension HomeTabBarView {
    private func setupViews() {
        backgroundColor = Design.safeAreaColor

        addSubview(buttonStackView)
        addSubview(plusButton)

        buttonStackView.addArrangedSubview(diaryButton)
        buttonStackView.addArrangedSubview(favoriteButton)

        setupTopLineView()
        setupSafeAreaView()
    }

    private func setupTopLineView() {
        let lineView = UIView(frame: .zero)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = Design.lineColor
        buttonStackView.addSubview(lineView)

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: Design.lineViewHeight)
        ])
    }

    private func setupSafeAreaView() {
        let safeAreaView = UIView(frame: .zero)
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.backgroundColor = Design.safeAreaColor
        addSubview(safeAreaView)

        NSLayoutConstraint.activate([
            safeAreaView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupContentsLayout() {
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: Design.stackViewHeight),

            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: Design.plusButtonWidth),
            plusButton.heightAnchor.constraint(equalToConstant: Design.plusButtonHeight)
        ])
    }
}

private enum Design {
    static let stackViewHeight: CGFloat = 55.0
    static let plusButtonHeight: CGFloat = 70.0
    static let plusButtonWidth: CGFloat = 70.0
    static let lineViewHeight: CGFloat = 1.0

    static let plusButton = Assets.Image.Home.plusButton

    static let lineColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let safeAreaColor = UIColor.white
}
