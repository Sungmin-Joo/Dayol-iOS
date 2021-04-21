//
//  TextStyleOptionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let alignmentButtonLeftMargin: CGFloat = 16.0
    static let alignmentButtonTopMargin: CGFloat = 9.0

    static let textSizeViewSize = CGSize(width: 104, height: 32)
    static let textSizeViewLeftMargin: CGFloat = 16.0

    static let additionalOptionViewRightMargin: CGFloat = 16.0
    static let additionalOptionViewHeight: CGFloat = 36.0

    static let lineSpaceOptionViewHeight: CGFloat = 55.0
}

class TextStyleOptionView: UIView {

    private let disposeBag = DisposeBag()

    private var alignment: TextStyleModel.Alignment = .leading {
        didSet { updateAlignmentButton() }
    }

    private var textSize = 0 {
        didSet { updateTextSize() }
    }

    private var additionalOptions: [TextStyleModel.AdditionalOption] = [] {
        didSet { updateAdditionalOptions() }
    }

    private var lineSpacing = 0 {
        didSet { updateLineSpacing() }
    }

    // MARK: - UI Property

    // 텍스트 정렬 옵션 설정 뷰
    private let alignmentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // 텍스트 사이즈 옵션 설정 뷰
    private let textSizeView: TextStyleTextSizeOptionView = {
        let view = TextStyleTextSizeOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // 볼드, 텍스트 라인 옵션 설정 뷰
    private let additionalOptionView: TextStyleAdditionalOptionView = {
        let view = TextStyleAdditionalOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // 줄 간격 옵션 설정 뷰
    private let lineSpaceOptionView: TextStyleLineSpaceOptionView = {
        let view = TextStyleLineSpaceOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTextStyleOption(
        alignment: TextStyleModel.Alignment,
        textSize: Int,
        additionalOptions: [TextStyleModel.AdditionalOption],
        lineSpacing: Int
    ) {
        self.alignment = alignment
        self.textSize = textSize
        self.additionalOptions = additionalOptions
        self.lineSpacing = lineSpacing
    }

}

// MARK: - UI update

extension TextStyleOptionView {

    private func updateAlignmentButton() {
        let image = UIImage(named: alignment.imageName)
        alignmentButton.setImage(image, for: .normal)
    }

    private func updateTextSize() {
        textSizeView.currentSize = textSize
    }

    private func updateAdditionalOptions() {
        additionalOptionView.currnetOptions = Set(additionalOptions)
    }

    private func updateLineSpacing() {
        lineSpaceOptionView.currentLineSpacing = lineSpacing
    }

}

// MARK: - Init

extension TextStyleOptionView {

    private func initView() {
        backgroundColor = .gray100
        addSubview(alignmentButton)
        addSubview(textSizeView)
        addSubview(additionalOptionView)
        addSubview(lineSpaceOptionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            alignmentButton.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: Design.alignmentButtonTopMargin),
            alignmentButton.leftAnchor.constraint(equalTo: leftAnchor,
                                                  constant: Design.alignmentButtonLeftMargin),

            textSizeView.leftAnchor.constraint(equalTo: alignmentButton.rightAnchor,
                                               constant: Design.alignmentButtonLeftMargin),
            textSizeView.centerYAnchor.constraint(equalTo: alignmentButton.centerYAnchor),
            textSizeView.widthAnchor.constraint(equalToConstant: Design.textSizeViewSize.width),
            textSizeView.heightAnchor.constraint(equalToConstant: Design.textSizeViewSize.height),

            additionalOptionView.centerYAnchor.constraint(equalTo: alignmentButton.centerYAnchor),
            additionalOptionView.rightAnchor.constraint(equalTo: rightAnchor,
                                                        constant: -Design.additionalOptionViewRightMargin),
            additionalOptionView.heightAnchor.constraint(equalToConstant: Design.additionalOptionViewHeight),

            lineSpaceOptionView.leftAnchor.constraint(equalTo: leftAnchor),
            lineSpaceOptionView.rightAnchor.constraint(equalTo: rightAnchor),
            lineSpaceOptionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineSpaceOptionView.heightAnchor.constraint(equalToConstant: Design.lineSpaceOptionViewHeight)
        ])
    }

    private func bindEvent() {
        alignmentButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.alignment = self.alignment.nextAlignment
            }
            .disposed(by: disposeBag)
    }

}
