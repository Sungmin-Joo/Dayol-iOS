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

    static let defaultFont: UIFont = .systemFont(ofSize: 15)
    static let defaultTextFieldSize = CGSize(width: 20, height: 0)
    static let defaultAttributes: [NSAttributedString.Key: Any] = [
        .kern: -0.28,
        .foregroundColor: UIColor.black
    ]

    static let containerInset = UIEdgeInsets(top: 13,
                                             left: dotDiameter / 2,
                                             bottom: 0,
                                             right: dotDiameter / 2)

    static let textColorSettingModalHeight: CGFloat = 441.0
}

class DYFlexibleTextField: UIView {

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
    private let leadingAccessoryView: DYTextBoxBulletPoint = {
        let view = DYTextBoxBulletPoint()
        view.isHidden = true
        view.frame.origin.y = 6
        view.frame.size = DYTextBoxBulletPoint.BulletType.BulletSize
        return view
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = Design.defaultFont
        textView.allowsEditingTextAttributes = true
        textView.typingAttributes = Design.defaultAttributes
        textView.inputAccessoryView = customInputAccessoryView
        return textView
    }()
    private let customInputAccessoryView = DYKeyboardInputAccessoryView(currentColor: .black)

    // MARK: Initialize

    convenience init() {
        let viewModel = DYFlexibleTextFieldViewModel(isFitStyle: false)
        self.init(viewModel: viewModel)
    }

    init(viewModel: DYFlexibleTextFieldViewModel) {
        let defaultFrame = CGRect(origin: .zero, size: Design.defaultTextFieldSize)
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

        // 디폴트 세팅
        textView.frame = containerView.bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.delegate = self
        containerView.addSubview(textView)
        containerView.addSubview(leadingAccessoryView)
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
            self.updateLeadingAccessoryView(type)
        }
        .store(in: &cancellable)

        bindAccessroyViewEvent()
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
private extension DYFlexibleTextField {

    func updateInputAccessoryView() {
        // TODO: - inputAccessory update
    }

    func bindAccessroyViewEvent() {
        customInputAccessoryView.keyboardDownButton.rx.tap
            .bind { [weak self] in
                self?.textView.endEditing(true)
            }
            .disposed(by: disposeBag)

        customInputAccessoryView.textStyleButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // TODO: color 연동
                self.presentTextStyleModal()
            }
            .disposed(by: disposeBag)

        customInputAccessoryView.textColorButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // TODO: text style 연동
                self.presentTextColorModal()
            }
            .disposed(by: disposeBag)

        customInputAccessoryView.bulletButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }

                switch self.viewModel.leadingAccessoryTypeSubject.value {
                case .dot:
                    self.viewModel.leadingAccessoryTypeSubject.send(.none)
                default:
                    self.viewModel.leadingAccessoryTypeSubject.send(.dot)
                }
            }
            .disposed(by: disposeBag)

        customInputAccessoryView.checkButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }

                switch self.viewModel.leadingAccessoryTypeSubject.value {
                case .checkBox(_):
                    self.viewModel.leadingAccessoryTypeSubject.send(.none)
                default:
                    self.viewModel.leadingAccessoryTypeSubject.send(.checkBox(isSelected: false))
                }
            }
            .disposed(by: disposeBag)

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

        // 현재 텍스트 뷰의 text설정값을 가져와야함
        //
        let viewModel = TextStyleViewModel(alignment: .leading,
                                           textSize: 16,
                                           additionalOptions: [.bold],
                                           lineSpacing: 26,
                                           font: .sandolGodic)
        modalVC.contentView = TextStyleView(viewModel: viewModel)

        keyWindow.rootViewController?.presentedViewController?.presentCustomModal(modalVC)
    }

    func presentTextColorModal() {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        let configuration = DYModalConfiguration(dimStyle: .clear, modalStyle: .custom(containerHeight: Design.textColorSettingModalHeight))
        let modalVC = DYModalViewController(configure: configuration,
                                            title: Text.textStyleColor,
                                            hasDownButton: true)
        // TODO: 현재 텍스트 필드의 컬러의 색상 연동
        let currentTextColor = UIColor.blue
        let contentView = ColorSettingView()
        contentView.set(color: currentTextColor)
        modalVC.contentView = contentView
        keyWindow.rootViewController?.presentedViewController?.presentCustomModal(modalVC)
    }
}

// MARK: - Calculate Frame

private extension DYFlexibleTextField {

    func calcTextViewHeight() {
        let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let transedSize = textView.sizeThatFits(size)
        print(transedSize)
        frame.size.height = transedSize.height + Design.containerInset.top + Design.containerInset.bottom
    }

    func calcTextViewWidth() {
        let size = CGSize(width: .greatestFiniteMagnitude, height: textView.frame.height)
        let transedSize = textView.sizeThatFits(size)
        print(transedSize)
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
        let transedSize = sizeThatFits(newSize)
        frame.size.width = newSize.width
        frame.size.height = transedSize.height
        recog.setTranslation(.zero, in: self)
        calcTextViewHeight()
    }

    @objc func didRecogLeftHandler(_ recog: UIPanGestureRecognizer) {
        let point = recog.translation(in: self)
        let changedX = center.x + point.x
        let changedY = center.y + point.y

        center = CGPoint(x: changedX, y: changedY)
        recog.setTranslation(.zero, in: self)
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
        calcTextViewWidth()
    }

}

// MARK: - Leding Accessory

extension DYFlexibleTextField {

    func updateLeadingAccessoryView(_ accessoryType: DYTextBoxBulletPoint.BulletType) {

        let textViewMargin = leadingAccessoryView.frame.size.width + 8
        let currentConatinerFrame = containerView.frame

        switch accessoryType {
        case .dot, .checkBox(_):
            leadingAccessoryView.isHidden = false
            textView.frame.origin.x = textViewMargin
            textView.frame.size.width = currentConatinerFrame.width - textViewMargin
        case .none:
            leadingAccessoryView.isHidden = true
            textView.frame.origin.x = 0
            textView.frame.size.width = currentConatinerFrame.width
        }

        leadingAccessoryView.updateAccessoryView(accessoryType)
        calcTextViewHeight()
    }

}

extension DYFlexibleTextField {
    private var currentAttr: NSRange {
        guard textView.text.isEmpty == false else { return NSRange(location: 0, length: textView.text.count) }
        let attrText = textView.attributedText
        let attributes = attrText?.attributes(at: 0, effectiveRange: nil)
        if let attributes = attributes {
            for attr in attributes {
                print(attr.key, attr.value)
            }
        }
        return NSRange(location: 0, length: textView.text.count)
    }
}

// MARK: - Font Style

extension DYFlexibleTextField {

    private var currentTextRange: NSRange {
        return NSRange(location: 0, length: textView.text.count)
    }

    func setBoldStyle() {
        let currentAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        currentAttributedString.addAttribute(.strokeWidth,
                                             value: UIFont.Weight.bold.strokeWidth,
                                             range: currentTextRange)
        textView.attributedText = currentAttributedString
    }

    func removeBoldStyle() {
        let currentAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        currentAttributedString.addAttribute(.strokeWidth,
                                             value: UIFont.Weight.regular.strokeWidth,
                                             range: currentTextRange)
        textView.attributedText = currentAttributedString
    }

    func setCancelLine() {
        let currentAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        currentAttributedString.addAttribute(.strikethroughStyle,
                                             value: NSUnderlineStyle.single.rawValue,
                                             range: currentTextRange)
        textView.attributedText = currentAttributedString
    }

    func removeCancelLine() {
        let currentAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        currentAttributedString.addAttribute(.strikethroughStyle,
                                             value: 0,
                                             range: currentTextRange)
        textView.attributedText = currentAttributedString
    }

    func setUnderLine() {
        let currentAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        currentAttributedString.addAttribute(.underlineStyle,
                                             value: NSUnderlineStyle.single.rawValue,
                                             range: currentTextRange)
        textView.attributedText = currentAttributedString
    }

    func removeUnderLine() {
        let currentAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        currentAttributedString.addAttribute(.underlineStyle,
                                             value: 0,
                                             range: currentTextRange)
        textView.attributedText = currentAttributedString
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

private extension UIFont.Weight {
    var strokeWidth: CGFloat {
        switch self {
        case .bold: return -3
        case .regular: return 0
        default: return 0
        }
    }
}
