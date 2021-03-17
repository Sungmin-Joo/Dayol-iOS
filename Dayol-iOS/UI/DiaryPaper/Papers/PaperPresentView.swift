//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import RxSwift

private enum Design {
    enum IPadOrientation {
        case landscape
        case portrait
    }
}


class PaperPresentView: UIView {
    private var iPadOrientation: Design.IPadOrientation {
        if self.frame.size.width > self.frame.size.height {
            return .landscape
        } else {
            return .portrait
        }
    }
    
    private var widthHeightRate: CGFloat {
        if paperStyle == .horizontal {
            return 662/1024
        }else {
            return 917/614
        }
    }
    
    private var widthRate: CGFloat {
        if iPadOrientation == .landscape {
            if paperStyle == .horizontal {
                return 1.0
            }else {
                return 242/667
            }
        } else {
            if paperStyle == .horizontal {
                return 614/768
            }else {
                return 1.0
            }
        }
    }
    
    let paperStyle: PaperStyle

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentMode = .center

        scrollView.bouncesZoom = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(paperStyle: PaperStyle) {
        self.paperStyle = paperStyle
        super.init(frame: .zero)
        initView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: - content inset + zoom scale 작업
        setupConstraints()
        setupContentInset()
    }

}

extension PaperPresentView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stackView
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
        stackView.addArrangedSubview(pageView)
    }

    func saveAndExit() {
        // TODO: - 각 페이지 별 데이터 저장
    }

    func clearPapers() {

    }

}

private extension PaperPresentView {

    func initView() {
        scrollView.addSubview(stackView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = paperStyle.maximumZoomIn
        addSubview(scrollView)
    }

    func setupConstraints() {
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            frameGuide.topAnchor.constraint(equalTo: topAnchor),
            frameGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
            contentGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

            stackView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, multiplier: widthRate),
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: widthHeightRate)
        ])
    }
    
    func setupContentInset() {
        let contentOffsetX: CGFloat = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let contentOffsetY: CGFloat = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
        scrollView.contentInset = UIEdgeInsets(top: -contentOffsetY, left: -contentOffsetX, bottom: 0, right: 0)
    }
}
