//
//  TextStyleOptionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

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
    private var cancellable: [AnyCancellable] = []

    // alignment는 customView 없이 버튼으로 관리
    private var alignment: TextStyleModel.Alignment = .leading {
        didSet { updateAlignmentButton() }
    }

    let attributesSubject: CurrentValueSubject<[NSAttributedString.Key: Any?], Never>
    var currentAttributes: [NSAttributedString.Key: Any?] {
        return attributesSubject.value
    }

    // MARK: - UI Property

    // 텍스트 정렬 옵션 설정 뷰
    private let alignmentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // 텍스트 사이즈 옵션 설정 뷰
    let textSizeView: TextStyleTextSizeOptionView = {
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

    init(attributes: [NSAttributedString.Key: Any?]) {
        self.attributesSubject = CurrentValueSubject(attributes)
        super.init(frame: .zero)
        initView()
        setupConstraints()
        configureAttributes()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - UI update

extension TextStyleOptionView {

    private func updateAlignmentButton() {
        let image = UIImage(named: alignment.imageName)
        alignmentButton.setImage(image, for: .normal)
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

    private func configureAttributes() {
        typealias Default = DYFlexibleTextField.DefaultOption
        let paragraphStyle = currentAttributes[.paragraphStyle] as? NSParagraphStyle
        let alignment = TextStyleModel.alignment(paragraphStyle: paragraphStyle)
        let font = currentAttributes[.font] as? UIFont ?? Default.defaultFont
        let additionalOptions = TextStyleModel.addtionalOptions(attributes: currentAttributes)
        let lineSpacing = paragraphStyle?.lineSpacing ?? Default.defaultLineSpacing

        self.alignment = alignment
        self.textSizeView.currentSize = Int(font.pointSize)
        self.additionalOptionView.currentOptions = Set(additionalOptions)
        self.lineSpaceOptionView.currentLineSpacing = lineSpacing
    }

    private func bindEvent() {
        alignmentButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.alignment = self.alignment.nextAlignment

                let paragraphStyle = NSMutableParagraphStyle()
                switch self.alignment {
                case .leading:
                    paragraphStyle.alignment = .left
                case .center:
                    paragraphStyle.alignment = .center
                case .trailing:
                    paragraphStyle.alignment = .right
                }

                var currentAttributes = self.attributesSubject.value
                currentAttributes[.paragraphStyle] = paragraphStyle
                self.attributesSubject.send(currentAttributes)
            }
            .disposed(by: disposeBag)

        textSizeView.textSizeSubject.sink { [weak self] fontSize in
            guard
                let self = self,
                let font = self.attributesSubject.value[.font] as? UIFont
            else { return }

            let newFont = font.withSize(CGFloat(fontSize))
            var newAttributes = self.attributesSubject.value
            newAttributes[.font] = newFont
            self.attributesSubject.send(newAttributes)
        }
        .store(in: &cancellable)

        lineSpaceOptionView.currentLineSpacingSubject.sink { [weak self] lineSpacing in
            guard let self = self else { return }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            var currentAttributes = self.attributesSubject.value
            currentAttributes[.paragraphStyle] = paragraphStyle

            self.attributesSubject.send(currentAttributes)
        }
        .store(in: &cancellable)

        additionalOptionView.optionsSubject.sink { [weak self] optionSet in
            guard
                let self = self,
                let font = self.attributesSubject.value[.font] as? UIFont
            else { return }

            var newAttributes = self.attributesSubject.value

            if optionSet.contains(.bold) {
                newAttributes[.font] = font.toBoldFont()
            } else {
                newAttributes[.font] = font.toRegularFont()
            }

            if optionSet.contains(.cancelLine) {
                newAttributes[.strikethroughStyle] =  NSUnderlineStyle.single.rawValue
            } else {
                newAttributes[.strikethroughStyle] = 0
            }

            if optionSet.contains(.underLine) {
                newAttributes[.underlineStyle] =  NSUnderlineStyle.single.rawValue
            } else {
                newAttributes[.underlineStyle] = 0
            }

            self.attributesSubject.send(newAttributes)
        }
        .store(in: &cancellable)

    }

}
