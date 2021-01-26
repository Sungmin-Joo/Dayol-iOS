//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import RxSwift

class PaperPresentView: UIView {

    let paperType: PaperType
    open var canAddPage: Bool {
        return false
    }

    // UI

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false

        scrollView.bouncesZoom = false
        return scrollView
    }()
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = CommonPaperDesign.defaultBGColor
        stackView.axis = .vertical
        stackView.spacing = .zero
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(frame: CGRect, paperType: PaperType) {
        self.paperType = paperType
        super.init(frame: frame)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: - content inset + zoom scale 작업
    }

}

extension PaperPresentView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentStackView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffset = scrollView.contentOffset

        if contentOffset.y < 0 {
            contentOffset.y = 0
            scrollView.setContentOffset(contentOffset, animated: false)
        }
    }

}

extension PaperPresentView {

    func addPage(_ pageView: BasePaper) {
        contentStackView.addArrangedSubview(pageView)
    }

    func saveAndExit() {
        // TODO: - 각 페이지 별 데이터 저장
    }

    func clearPapers() {
        contentStackView.arrangedSubviews.forEach {
            contentStackView.removeArrangedSubview($0)
        }
    }

}

private extension PaperPresentView {

    func initView() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = paperType.maximumZoomIn
        scrollView.addSubview(contentStackView)
        addSubview(scrollView)
    }

    func setupConstraints() {
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            frameGuide.topAnchor.constraint(equalTo: topAnchor),
            frameGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
        ])
    }
}
