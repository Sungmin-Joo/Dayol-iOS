//
//  PaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import UIKit

private enum Design {
    static let maximumZoomIn: CGFloat = 3.0
    static let minimumZoomOut: CGFloat = 1.0
}

class PaperView: UIView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = Design.minimumZoomOut
        scrollView.maximumZoomScale = Design.maximumZoomIn
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonPaperDesign.defaultBGColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

extension PaperView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}

private extension PaperView {

    func initView() {
        scrollView.delegate = self
        scrollView.addSubview(contentView)
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

            contentGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentGuide.widthAnchor.constraint(equalTo: frameGuide.widthAnchor),
            contentGuide.heightAnchor.constraint(equalTo: frameGuide.heightAnchor),
        ])
    }
}
