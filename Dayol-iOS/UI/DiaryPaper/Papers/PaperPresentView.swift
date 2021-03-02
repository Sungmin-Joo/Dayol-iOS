//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import RxSwift

class PaperPresentView: UIView {

    let paperStyle: PaperStyle
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

    init(frame: CGRect, paperStyle: PaperStyle) {
        self.paperStyle = paperStyle
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
        return scrollView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffset = scrollView.contentOffset

        if contentOffset.y < 0 {
            contentOffset.y = 0
        }
    }

}

extension PaperPresentView {

    func addPage(_ pageView: BasePaper) {

    }

    func saveAndExit() {
        // TODO: - 각 페이지 별 데이터 저장
    }

    func clearPapers() {

    }

}

private extension PaperPresentView {

    func initView() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = paperStyle.maximumZoomIn
        addSubview(scrollView)
    }

    func setupConstraints() {
        let frameGuide = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            frameGuide.topAnchor.constraint(equalTo: topAnchor),
            frameGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
