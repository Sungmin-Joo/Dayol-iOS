//
//  HomeTabBarView.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//
import UIKit
import GoogleMobileAds
import RxCocoa
import RxSwift

protocol HomeTabbarDelegate: AnyObject {
    func didTapMenu(_ type: HomeTabBarView.EventType)
}

class HomeTabBarView: UIView, GADBannerPresentable {
    enum TabType {
        case diary
        case favorite
    }

    enum EventType {
        case showList(tab: TabType)
        case add
    }

    weak var delegate: HomeTabbarDelegate?

    private let plusFloatingButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.plusFloatingButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let diaryButton = HomeTabBarButton(style: .diary)

    private let favoriteButton = HomeTabBarButton(style: .favorite)

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        return stackView
    }()

    let adBannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Design.lineViewHeight
        return stackView
    }()

    var currentTabMode: TabType {
        didSet { updateTabBarState() }
    }

    private let disposeBag = DisposeBag()

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
        plusFloatingButton.rx.tap.bind { [weak self] in
            self?.delegate?.didTapMenu(.add)
        }
        .disposed(by: disposeBag)

        diaryButton.rx.tap.bind { [weak self] in
            self?.currentTabMode = .diary
            self?.delegate?.didTapMenu(.showList(tab: .diary))
        }
        .disposed(by: disposeBag)

        favoriteButton.rx.tap.bind { [weak self] in
            self?.currentTabMode = .favorite
            self?.delegate?.didTapMenu(.showList(tab: .favorite))
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

        buttonStackView.addArrangedSubview(diaryButton)
        buttonStackView.addArrangedSubview(favoriteButton)

        contentStackView.addArrangedSubview(adBannerView)
        contentStackView.addArrangedSubview(buttonStackView)

        addSubview(contentStackView)
        addSubview(plusFloatingButton)

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
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            adBannerView.heightAnchor.constraint(equalToConstant: GADManager.Design.adBannerHeight),
            buttonStackView.heightAnchor.constraint(equalToConstant: Design.stackViewHeight),

            plusFloatingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusFloatingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            plusFloatingButton.widthAnchor.constraint(equalToConstant: Design.plusButtonWidth),
            plusFloatingButton.heightAnchor.constraint(equalToConstant: Design.plusButtonHeight),
        ])
    }
}

private enum Design {
    static let stackViewHeight: CGFloat = 55.0
    static let plusButtonHeight: CGFloat = 70.0
    static let plusButtonWidth: CGFloat = 70.0
    static let lineViewHeight: CGFloat = 1.0

    static let plusFloatingButton = Assets.Image.Home.plusButton

    static let lineColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let safeAreaColor = UIColor.white
}
