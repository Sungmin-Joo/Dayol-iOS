//
//  ScheduleModalHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/09.
//

import UIKit
import RxSwift

private enum Design {
    enum Label {
        static let titleFont = UIFont.appleBold(size: 18)
        static let titleTextColor = UIColor.black
        static let titleLetterSpace: CGFloat = -0.33
    }

    enum Image {
        static let cancel = UIImage(named: "cancelButton")
        static let done = UIImage(named: "doneButton")
    }

    enum Size {
        static let buttonSize: CGSize = .init(width: 40, height: 40)
    }

    enum Margin {
        static let doneTrailing: CGFloat = 9
        static let cancelLeading: CGFloat = 9
    }
}

private enum Text: String {
    case title = "일정"
}

final class ScheduleModalHeaderView: UIView {
    enum Event {
        case done
        case cancel
    }

    private let disposeBag = DisposeBag()
    let didTappedButton = PublishSubject<Event>()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(text: Text.title.rawValue,
                                                        font: Design.Label.titleFont,
                                                        align: .center,
                                                        letterSpacing: Design.Label.titleLetterSpace,
                                                        foregroundColor: Design.Label.titleTextColor)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.frame.size = Design.Size.buttonSize
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.Image.cancel, for: .normal)

        return button
    }()

    private let doneButton: UIButton = {
        let button = UIButton()
        button.frame.size = Design.Size.buttonSize
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.Image.done, for: .normal)

        return button
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(cancelButton)
        addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Design.Margin.doneTrailing),
            doneButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.Margin.cancelLeading),
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func bind() {
        cancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.didTappedButton.onNext(.cancel)
            })
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.didTappedButton.onNext(.done)
            })
            .disposed(by: disposeBag)

    }
}
