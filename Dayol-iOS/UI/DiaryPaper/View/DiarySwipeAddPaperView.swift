//
//  DiarySwipeAddPaperView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/15.
//

import UIKit
import RxSwift

private enum Design {
    enum Image {
        static let swipeImage: UIImage? = UIImage(named: "progress_swipe")
        static let plusImage: UIImage? = UIImage.add.withTintColor(.dayolBrown) // TODO: 이미지 요청
    }

    enum Margin {
        static let progressLabelSpace: CGFloat = 8
        static let progressSize: CGSize = .init(width: 48, height: 48)
    }

    enum Label {
        static let letterSpace: CGFloat = -0.24
        static let textFont: UIFont = UIFont.appleMedium(size: 13)
        static let textColor: UIColor = .gray900
    }
}

private enum Text: String {
    case pullToAddPaper = "당겨서 속지 추가"
    case releaseToAddPaper = "놓으면 속지 추가"
}

final class DiarySwipeAddPaperView: UIView {
    private let disposeBag = DisposeBag()
    var readyToAdd: Bool = false

    private let progressView: CircularProgressView = {
        let progressView = CircularProgressView(usesClockwise: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressImage = Design.Image.swipeImage

        return progressView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(textLabel)
        addSubview(progressView)
        bind()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: Design.Margin.progressSize.height),
            progressView.widthAnchor.constraint(equalToConstant: Design.Margin.progressSize.width),

            textLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: Design.Margin.progressLabelSpace),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bind() {
        progressView.progressDidChanged
            .subscribe(onNext: { [weak self] progress in
                guard let self = self else { return }

                if progress > 1 {
                    self.readyToAdd = true
                    self.progressView.progressImage = Design.Image.plusImage
                    self.descText = Text.releaseToAddPaper.rawValue
                } else {
                    self.readyToAdd = false
                    self.progressView.progressImage = Design.Image.swipeImage
                    self.descText = Text.pullToAddPaper.rawValue
                }

            })
            .disposed(by: disposeBag)
    }

    func setProgress(_ progress: CGFloat) {
        progressView.setProgress(progress, animated: true)
    }
}

extension DiarySwipeAddPaperView {
    var descText: String? {
        get {
            return textLabel.attributedText?.string
        }
        set {
            UIView.transition(with: textLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.textLabel.attributedText = NSAttributedString.build(text: newValue ?? "",
                                                                    font: Design.Label.textFont,
                                                                    align: .center,
                                                                    letterSpacing: Design.Label.letterSpace,
                                                                    foregroundColor: Design.Label.textColor)
            }, completion: nil)
        }
    }
}
