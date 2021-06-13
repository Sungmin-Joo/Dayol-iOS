//
//  DYFlexibleTextField.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/05/30.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

private enum Design {
    static let dotDiameter: CGFloat = 8.0
    static let dotColor = UIColor(decimalRed: 0, green: 122, blue: 255)
    static let lineColor = UIColor(decimalRed: 157, green: 157, blue: 157)

    static let delButtonSize = CGSize(width: 18, height: 18)
    static let delButtonImage = Assets.Image.DYTextField.delete

    static let containerInset = UIEdgeInsets(top: 13,
                                             left: dotDiameter / 2,
                                             bottom: 0,
                                             right: dotDiameter / 2)

    static let textColorSettingModalHeight: CGFloat = 441.0
    static let bulletTopMargin: CGFloat = 6.0
    static let bulletLeftMargin: CGFloat = 7.0
}

class DYFlexibleTextField: UIView {

    enum DefaultOption {
        static let defaultFont: UIFont = .systemFont(ofSize: 15)
        static let defaultTextFieldSize = CGSize(width: 60, height: 0)
        static let defaultLineSpacing: CGFloat = 0
        static let defaultAttributes: [NSAttributedString.Key: Any] = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            paragraphStyle.lineSpacing = defaultLineSpacing
            return [
                .font: defaultFont,
                .kern: -0.28,
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
        }()
    }

    private var cancellable: [AnyCancellable] = []
    private var isEditMode = false {
        didSet {
            updateContainerPath()
            if isEditMode {
                showHandler()
            } else {
                hideHandler()
            }
        }
    }
    let disposeBag = DisposeBag()
    var deleteCompletion: (() -> Void)?
    private(set) var viewModel: DYFlexibleTextFieldViewModel

    // MARK: UI Property

    private let containerLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineDashPattern = [2, 2]
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Design.lineColor.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    private let containerView = UIView()
    private let leftHandler: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.image = drawDotImage(color: Design.dotColor, dotDiameter: Design.dotDiameter)
        return imageView
    }()
    private let rightHandler: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.image = drawDotImage(color: Design.dotColor, dotDiameter: Design.dotDiameter)
        return imageView
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(Design.delButtonImage, for: .normal)
        button.frame.size = Design.delButtonSize
        return button
    }()
    private let bulletPointView: DYTextBoxBulletPoint = {
        let view = DYTextBoxBulletPoint()
        view.isHidden = true
        view.frame.origin.y = Design.bulletTopMargin
        view.frame.origin.x = Design.bulletLeftMargin
        view.frame.size = DYTextBoxBulletPoint.BulletType.bulletSize
        return view
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = DefaultOption.defaultFont
        textView.allowsEditingTextAttributes = true
        textView.typingAttributes = DefaultOption.defaultAttributes
        textView.inputAccessoryView = customInputAccessoryView
        return textView
    }()
    private let customInputAccessoryView = DYKeyboardInputAccessoryView(currentColor: .black)

    // MARK: Initialize

    convenience init() {
        let viewModel = DYFlexibleTextFieldViewModel()
        self.init(viewModel: viewModel)
    }

    init(viewModel: DYFlexibleTextFieldViewModel) {
        let defaultFrame = CGRect(origin: .zero, size: DefaultOption.defaultTextFieldSize)
        self.viewModel = viewModel
        super.init(frame: defaultFrame)
        setupContainerView()
        setupGesture()
        setupEvent()
        calcTextViewHeight()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Overrode Func

    override func layoutSubviews() {
        super.layoutSubviews()
        updateContainerFrame()
        updateContainerPath()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let selfPoint = convert(point, to: self)
        let inputAccessoryPoint = convert(point, to: customInputAccessoryView)

        if bounds.contains(selfPoint) == false && customInputAccessoryView.bounds.contains(inputAccessoryPoint) == false {
            endEditing(false)
            if textView.text.isEmpty {
                removeDYTextField()
            }
        }

        return super.hitTest(point, with: event)
    }

    override func becomeFirstResponder() -> Bool {
        let _ = textView.becomeFirstResponder()
        return super.becomeFirstResponder()
    }

}

// MARK: - Setup

private extension DYFlexibleTextField {

    func setupContainerView() {
        containerView.layer.addSublayer(containerLayer)
        customInputAccessoryView.delegate = self
        // 디폴트 세팅
        textView.frame = containerView.bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.delegate = self
        containerView.addSubview(textView)
        containerView.addSubview(bulletPointView)
        addSubview(containerView)
        addSubview(leftHandler)
        addSubview(rightHandler)

        deleteButton.center = CGPoint(x: bounds.width / 2.0,
                                      y: Design.delButtonSize.height / 2.0)
        deleteButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        addSubview(deleteButton)
    }

    func setupGesture() {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(didRecogDrag(_:)))
        addGestureRecognizer(panGesture)

        let rightHandleGesture = UIPanGestureRecognizer()
        rightHandleGesture.addTarget(self, action: #selector(didRecogRightHandler(_:)))
        rightHandler.addGestureRecognizer(rightHandleGesture)

        let leftHandleGesture = UIPanGestureRecognizer()
        leftHandleGesture.addTarget(self, action: #selector(didRecogLeftHandler(_:)))
        leftHandler.addGestureRecognizer(leftHandleGesture)
    }

    func setupEvent() {
        deleteButton.rx.tap.bind { [weak self] in
            self?.removeDYTextField()
        }
        .disposed(by: disposeBag)

        viewModel.leadingAccessoryTypeSubject.sink { [weak self] type in
            guard let self = self else { return }
            self.updateBulletPointView(type)
        }
        .store(in: &cancellable)

        viewModel.didSetAttributedString = { [weak self] attributedString in
            self?.textView.attributedText = attributedString
        }
    }

}

// MARK: View Update

private extension DYFlexibleTextField {

    func updateContainerFrame() {
        let containerFrame = CGRect(x: Design.containerInset.left,
                                    y: Design.containerInset.top,
                                    width: frame.width - Design.containerInset.left - Design.containerInset.right,
                                    height: frame.height - Design.containerInset.top - Design.containerInset.bottom)
        containerView.frame = containerFrame

        let handlerOriginY = containerFrame.minY + (containerFrame.height / 2.0) - (Design.dotDiameter / 2.0)
        leftHandler.frame = CGRect(x: 0,
                                   y: handlerOriginY,
                                   width: Design.dotDiameter,
                                   height: Design.dotDiameter)

        rightHandler.frame = CGRect(x: bounds.width - Design.dotDiameter,
                                    y: handlerOriginY,
                                    width: Design.dotDiameter,
                                    height: Design.dotDiameter)
    }

    func updateContainerPath() {
        guard isEditMode else {
            containerLayer.path = nil
            return
        }
        let path = UIBezierPath(rect: containerView.bounds)
        containerLayer.path = path.cgPath
    }

    func showHandler() {
        leftHandler.isHidden = false
        rightHandler.isHidden = false
        deleteButton.isHidden = textView.text.isEmpty
    }

    func hideHandler() {
        leftHandler.isHidden = true
        rightHandler.isHidden = true
        deleteButton.isHidden = true
    }

    func removeDYTextField() {
        deleteCompletion?()
        removeFromSuperview()
    }

}

// MARK: - Input Accessory View

extension DYFlexibleTextField: DYKeyboardInputAccessoryViewDelegate {
    func didTapKeyboardDownButton() {
        textView.endEditing(true)
    }

    func didTapTextStyleButton() {
        presentTextStyleModal()
    }

    func didTapTextColorButton() {
        presentTextColorModal()
    }

    func didTapBulletButton() {
        switch self.viewModel.leadingAccessoryTypeSubject.value {
        case .dot:
            viewModel.leadingAccessoryTypeSubject.send(.none)
        default:
            viewModel.leadingAccessoryTypeSubject.send(.dot)
        }
    }

    func didTapCheckboxButton() {
        switch self.viewModel.leadingAccessoryTypeSubject.value {
        case .checkBox(_):
            viewModel.leadingAccessoryTypeSubject.send(.none)
        default:
            viewModel.leadingAccessoryTypeSubject.send(.checkBox(isSelected: false))
        }
    }

    func updateInputAccessoryView() {
        let textColor = currentAttributes[.foregroundColor] as? UIColor
        customInputAccessoryView.textColorButton.backgroundColor = textColor
    }

}

// MARK: - Modal

private extension DYFlexibleTextField {

    enum Text {
        static var textStyleTitle: String {
            return "text_style_title".localized
        }
        static var textStyleColor: String {
            return "text_style_color".localized
        }
    }

    func presentTextStyleModal() {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        let configuration = DYModalConfiguration(dimStyle: .clear, modalStyle: .small)
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.textStyleTitle,
                                            hasDownButton: true)
        let contentView = TextStyleView(attributes: currentAttributes)

        contentView.attributesSubject.sink { [weak self] attributes in
            attributes.forEach { key, value in
                guard let value = value else { return }
                self?.setAttributes(key: key, value: value)
            }
        }
        .store(in: &cancellable)

        modalVC.contentView = contentView

        keyWindow.rootViewController?.presentedViewController?.presentCustomModal(modalVC)
    }

    func presentTextColorModal() {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        let configuration = DYModalConfiguration(dimStyle: .clear, modalStyle: .custom(containerHeight: Design.textColorSettingModalHeight))
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.textStyleColor,
                                            hasDownButton: true)
        // TODO: 현재 텍스트 필드의 컬러의 색상 연동
        var currentTextColor = UIColor.black

        if let color = currentAttributes[.foregroundColor] as? UIColor {
            currentTextColor = color
        }

        let contentView = ColorSettingView()
        contentView.set(color: currentTextColor)
        contentView.colorSubject.sink { [weak self] color in
            self?.setAttributes(key: .foregroundColor, value: color)
        }
        .store(in: &cancellable)
        
        modalVC.contentView = contentView
        keyWindow.rootViewController?.presentedViewController?.presentCustomModal(modalVC)
    }
}

// MARK: - Calculate Frame

private extension DYFlexibleTextField {

    func calcTextViewHeight() {
        let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let transedSize = textView.sizeThatFits(size)
        frame.size.height = transedSize.height + Design.containerInset.top + Design.containerInset.bottom
    }

    func calcTextViewWidth() {
        let size = CGSize(width: .greatestFiniteMagnitude, height: textView.frame.height)
        let transedSize = textView.sizeThatFits(size)
        let calcedWidth = transedSize.width + Design.containerInset.left + Design.containerInset.right
        frame.size.width = max(calcedWidth, frame.width)
    }

}

// MARK: - Gesture

private extension DYFlexibleTextField {

    @objc func didRecogDrag(_ recog: UIPanGestureRecognizer) {
        guard let superview = superview else { return }

        let point = recog.translation(in: self)
        // 업데이트된 좌표가 superview를 벗어나면 변화를 현재 center 유지
        // TODO: - target view에 대한 마스킹
        let changedCenter = CGPoint(x: center.x + point.x, y: center.y + point.y)

        if superview.bounds.contains(changedCenter) {
            center = changedCenter
        }

        recog.setTranslation(.zero, in: self)
    }

    @objc func didRecogRightHandler(_ recog: UIPanGestureRecognizer) {
        let point = recog.translation(in: self)
        let newSize = CGSize(width: frame.width + point.x, height: frame.height)
        updateTextViewFrameIfNeeded(newSize)
        recog.setTranslation(.zero, in: self)
    }

    @objc func didRecogLeftHandler(_ recog: UIPanGestureRecognizer) {
        let point = recog.translation(in: self)

        let newSize = CGSize(width: frame.width - point.x, height: frame.height)
        updateTextViewFrameIfNeeded(newSize)
        frame.origin.x += point.x
        recog.setTranslation(.zero, in: self)
    }

    private func updateTextViewFrameIfNeeded(_ size: CGSize) {
        guard size.width > DefaultOption.defaultTextFieldSize.width else { return }
        let transedSize = sizeThatFits(size)
        frame.size.width = size.width
        frame.size.height = transedSize.height
        calcTextViewHeight()
    }

}

// MARK: - UITextViewDelegate

extension DYFlexibleTextField: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        updateInputAccessoryView()
        isEditMode = true
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        isEditMode = false
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if isEditMode {
            deleteButton.isHidden = textView.text.isEmpty
        }

        // TODO: - 미모티콘 처리 필요
        // 텍스트 처리 가능할 것 같은데..
        calcTextViewWidth()

        // TODO: - fit mode일때 프레임 계산 로직 수정
        if textView.text.last == "\n" {
            calcTextViewHeight()
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        updateInputAccessoryView()
    }

}

// MARK: - TextBox Bullet Point

extension DYFlexibleTextField {

    func updateBulletPointView(_ accessoryType: DYTextBoxBulletPoint.BulletType) {

        let textViewMargin = bulletPointView.frame.size.width + 8
        let currentConatinerFrame = containerView.frame

        switch accessoryType {
        case .dot, .checkBox(_):
            bulletPointView.isHidden = false
            textView.frame.origin.x = textViewMargin
            textView.frame.size.width = currentConatinerFrame.width - textViewMargin
        case .none:
            bulletPointView.isHidden = true
            textView.frame.origin.x = 0
            textView.frame.size.width = currentConatinerFrame.width
        }

        bulletPointView.updateAccessoryView(accessoryType)
        calcTextViewHeight()
    }

}

// MARK: - Attributes

extension DYFlexibleTextField {

    /// 현재 textView의 커서, 혹은 선택된 범위에 대한 attributes를 반환
    ///
    /// - textView의 마지막 커서라면, 혹은 선택된 영역의 길이가 0 이라면, typingAttributes를 그대로 반환
    /// - select된 부분이 있다면 os 기준으로 해당 범위에 있는 attributes를 반환
    private var currentAttributes: [NSAttributedString.Key : Any?] {
        let lastCursorRange = NSRange(location: textView.text.count, length: 0)

        guard
            lastCursorRange != textView.selectedRange,
            textView.selectedRange.length != 0,
            let attributedText = textView.attributedText
        else {
            return textView.typingAttributes
        }

        var selectedRange = textView.selectedRange
        let attributes = attributedText.attributes(at: selectedRange.location,
                                                   effectiveRange: &selectedRange)
        return attributes
    }

    /// 현재 textView의  typingAttributes, 범위의 텍스트에 attribute 적용
    private func setAttributes(key: NSAttributedString.Key, value: Any) {
        guard let attributedText = textView.attributedText else { return }

        defer {
            updateInputAccessoryView()
        }

        var typingAttributes = textView.typingAttributes
        typingAttributes[key] = value
        textView.typingAttributes = typingAttributes

        var targetRange = textView.selectedRange
        let tempSelectRange = textView.selectedRange

        // paragraphStyle일 경우 targetRange를 전체로 적용한다.
        if key == .paragraphStyle {
            targetRange = NSRange(location: 0, length:  textView.text.count)
        }

        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedString.addAttribute(key, value: value, range: targetRange)
        textView.attributedText = mutableAttributedString
        textView.selectedRange = tempSelectRange

        calcTextViewHeight()
    }
}

// MARK: - DecorationTextFieldItem

extension DYFlexibleTextField {

    func toItem(id: String, parentId: String) -> DecorationTextFieldItem? {
        return viewModel.toItem(id: id,
                                parentId: parentId,
                                text: textView.attributedText,
                                x: Float(frame.origin.x),
                                y: Float(frame.origin.y),
                                width: Float(frame.width),
                                height: Float(frame.height))
    }

}

// MARK: - Util

extension DYFlexibleTextField {

    static func drawDotImage(color: UIColor, dotDiameter: CGFloat) -> UIImage? {
        let imageSize = CGSize(width: dotDiameter, height: dotDiameter)
        UIGraphicsBeginImageContext(imageSize)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        UIGraphicsPushContext(context)

        context.setFillColor(color.cgColor)

        let circlePath = CGPath(ellipseIn: CGRect(origin: .zero, size: imageSize),
                                transform: nil)
        context.addPath(circlePath)
        context.fillPath()

        UIGraphicsPopContext()

        let buttonImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return buttonImage?.withRenderingMode(.alwaysOriginal)

    }

}
