//
//  OnboadingView.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import UIKit
import RxSwift

class OnboadingView: UIView {
    // MARK: Mock Data
    private struct Data {
        let image: UIImage?
        let description: String
        let optionStrings: [String]

        static func make() -> [Data] {
            return [
                Data(
                    image: UIImage(named: "onboarding_img1"),
                    description: "일정, 할일, 메모, 일기까지.\n내가 원하는 속지들로 자유롭게 구성한\n나만의 다이어리를 만들고 꾸며보세요!",
                    optionStrings: ["내가 원하는 속지", "나만의 다이어리"]
                ),
                Data(
                    image: UIImage(named: "onboarding_img2"),
                    description: "소중한 다이어리별로 암호를 설정할 수 있고,\n데이터는 iCloud 동기화 할 수 있어요.",
                    optionStrings: ["암호를 설정", "iCloud 동기화"]
                ),
                Data(
                    image: UIImage(named: "onboarding_img3"),
                    description: "먼슬리, 위클리 속지는 일정 등록은 물론\n다른 속지들을 연결할 수도 있어요! ",
                    optionStrings: ["다른 속지들을 연결"]
                ),
                Data(
                    image: UIImage(named: "onboarding_img4"),
                    description: "더 많은 사용법 및 TIP은 ‘설정’의\n‘다욜 사용 가이드’를 참고해주세요! 그럼 다욜 시작해볼까요?",
                    optionStrings: ["‘설정’", "‘다욜 사용 가이드’"]
                )
            ]
        }
    }

    // MARK: - Content
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: PageView
    private let contentPageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .dayolBrown
        return pageControl
    }()

    private let pageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 90
        return stackView
    }()

    private let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.gray800, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.addLetterSpacing(-0.3)
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.dayolBrown, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.titleLabel?.addLetterSpacing(-0.33)
        return button
    }()

    private let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.titleLabel?.addLetterSpacing(-0.31)
        button.setBackgroundColor(.dayolBrown, for: .normal)
        button.alpha = 0
        return button
    }()

    private let datas = Data.make()

    init() {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureView() {
        addSubview(contentPageScrollView)
        addSubview(pageControl)
        addSubview(skipButton)
        addSubview(nextButton)
        addSubview(startButton)

        contentPageScrollView.delegate = self
        pageControl.numberOfPages = datas.count
        pageControl.currentPage = .zero
        pageControl.isUserInteractionEnabled = false

        skipButton.addTarget(self, action: #selector(skipAction(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)

        configureConstraints()
    }

    func configureOnboard() {
        datas.enumerated().forEach {
            let index = $0.offset
            let image = $0.element.image
            let description = $0.element.description
            let optionStrings = $0.element.optionStrings

            let contentStackView = OnboadingContentView(image: image, description: description, optionStrings: optionStrings)
            let position = CGPoint(x: frame.width * CGFloat(index), y: 0)
            let size = contentPageScrollView.frame.size

            contentStackView.frame = CGRect(origin: position, size: size)
            contentPageScrollView.addSubview(contentStackView)
            contentPageScrollView.contentSize.width = size.width * CGFloat(index + 1)
        }
    }
}

// MARK: - Action

private extension OnboadingView {
    @objc func skipAction(_ sender: UIButton) {
        let posX = contentPageScrollView.contentSize.width - self.frame.width
        contentPageScrollView.setContentOffset(CGPoint(x: posX, y: .zero), animated: true)
    }

    @objc func nextAction(_ sender: UIButton) {
        let posX = (self.frame.width * CGFloat((pageControl.currentPage + 1)) + 1)
        contentPageScrollView.setContentOffset(CGPoint(x: posX, y: .zero), animated: true)
    }

    @objc func startAction(_ sender: UIButton) {
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.isNavigationBarHidden = true

        AppDelegate.shared?.window?.switchRootViewController(navigationController)
    }
}

// MARK: Set Constraints

private extension OnboadingView {
    func configureConstraints() {
        NSLayoutConstraint.activate([
            contentPageScrollView.widthAnchor.constraint(equalTo: widthAnchor),
            contentPageScrollView.heightAnchor.constraint(equalToConstant: 81+38+250),

            skipButton.widthAnchor.constraint(equalToConstant: 55),
            skipButton.heightAnchor.constraint(equalToConstant: 19),
            skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34),
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: 31),
            nextButton.heightAnchor.constraint(equalToConstant: 21),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            pageControl.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -110),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentPageScrollView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            contentPageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentPageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Paging

extension OnboadingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x / self.frame.width)

        let shouldShowStartButton = (pageControl.currentPage + 1) >= datas.count
        UIView.animate(withDuration: 0.3) {
            self.skipButton.alpha = shouldShowStartButton ? 0.0 : 1.0
            self.nextButton.alpha = shouldShowStartButton ? 0.0 : 1.0
            self.startButton.alpha = shouldShowStartButton ? 1.0 : 0.0
        }
    }
}
