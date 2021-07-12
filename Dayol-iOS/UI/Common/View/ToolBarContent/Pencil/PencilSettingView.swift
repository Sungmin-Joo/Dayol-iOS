//
//  PencilSettingView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/10.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let stackViewSpacing: CGFloat = 13.0
    static let stackViewSize = CGSize(width: 343, height: 48)
    static let scrollViewSideInset: CGFloat = 16
    static let scrollViewTopInset: CGFloat = 15

    static let penOnIcon = UIImage(named: "toolbar_btnPenOn")
    static let penOffIcon = UIImage(named: "toolbar_btnPen")
    static let markerOnIcon = UIImage(named: "toolbar_btnHighlightOn")
    static let markerOffIcon = UIImage(named: "toolbar_btnHighlight")
    static let pencilOnIcon = UIImage(named: "toolbar_btnPencilOn")
    static let pencilOffIcon = UIImage(named: "toolbar_btnPencil")
    static let eraseOnIcon = UIImage(named: "toolbar_btnEraserOn")
    static let eraseOffIcon = UIImage(named: "toolbar_btnEraser")
    static let lassoOnIcon = UIImage(named: "toolbar_btnLassoOn")
    static let lassoOffIcon = UIImage(named: "toolbar_btnLasso")
}

class PencilSettingView: UIView {
    typealias DetailViewInfo = (contents: UIView, sender: UIButton, preferredSize: CGSize)
    static let preferredSize = CGSize(width: 335, height: 48)
    let disposeBag = DisposeBag()
    private(set) var currentColor: UIColor
    private(set) var currentToolType: DYDrawTool

    var showColorPicker: ((UIColor) -> ())?
    var showDetailPiker: ((DetailViewInfo) -> Void)?
    var currentToolSubject = PublishSubject<DYDrawTool>()
    var currentColorSubject: PublishSubject<UIColor> {
        return colorButton.currentColorSubject
    }

    // MARK: UI Property

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset.top = Design.scrollViewTopInset
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Design.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let penButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.penOffIcon, for: .normal)
        button.setImage(Design.penOnIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let markerButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.markerOffIcon, for: .normal)
        button.setImage(Design.markerOnIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pencilButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.pencilOffIcon, for: .normal)
        button.setImage(Design.pencilOnIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let eraseButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.eraseOffIcon, for: .normal)
        button.setImage(Design.eraseOnIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let lassoButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.lassoOffIcon, for: .normal)
        button.setImage(Design.lassoOnIcon, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var colorButton: PencilSettingColorButton = {
        let button = PencilSettingColorButton(currentColor: currentColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var toolButtons: [UIButton] {
        return [penButton, markerButton, pencilButton, eraseButton, lassoButton]
    }

    // 컬러 버튼 추가

    override func layoutSubviews() {
        super.layoutSubviews()
        calcScrollViewInset()
    }

    private func calcScrollViewInset() {
        if frame.width < 375 {
            scrollView.contentInset.left = Design.scrollViewSideInset
            scrollView.contentInset.right = Design.scrollViewSideInset
        } else {
            let sideInset = frame.width - Design.stackViewSize.width
            scrollView.contentInset.left = sideInset / 2.0
            scrollView.contentInset.right = sideInset / 2.0
            scrollView.isScrollEnabled = false
        }
    }

    // MARK: Init

    init(currentColor: UIColor, toolType: DYDrawTool) {
        self.currentColor = currentColor
        self.currentToolType = toolType
        super.init(frame: .zero)

        initView()
        setupConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Private Initialize

private extension PencilSettingView {

    func initView() {
        toolButtons.forEach { stackView.addArrangedSubview($0) }
        stackView.addArrangedSubview(colorButton)
        
        scrollView.addSubview(stackView)
        addSubview(scrollView)
    }

    func setupConstraints() {
        let frameLayoutGuide = scrollView.frameLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: Design.stackViewSize.width),
            stackView.heightAnchor.constraint(equalToConstant: Design.stackViewSize.height),

            frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            frameLayoutGuide.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            frameLayoutGuide.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func bindEvent() {
        penButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.penButton.isSelected == false else {
                let content = PencilSettingDetailView(penType: .pen, currentColor: self.currentColor)
                let info = DetailViewInfo(
                    contents: content,
                    sender: self.penButton,
                    preferredSize: PencilSettingDetailView.preferredSize
                )
                self.showDetailPiker?(info)
                return
            }
            self.deselectToolButtons()
            self.penButton.isSelected = true
        }
        .disposed(by: disposeBag)

        markerButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.markerButton.isSelected == false else {
                let content = PencilSettingDetailView(penType: .marker, currentColor: self.currentColor)
                let info = DetailViewInfo(
                    contents: content,
                    sender: self.penButton,
                    preferredSize: PencilSettingDetailView.preferredSize
                )
                self.showDetailPiker?(info)
                return
            }

            self.deselectToolButtons()
            self.markerButton.isSelected = true

        }
        .disposed(by: disposeBag)

        pencilButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.pencilButton.isSelected == false else {
                let content = PencilSettingDetailView(penType: .pencil, currentColor: self.currentColor)
                let info = DetailViewInfo(
                    contents: content,
                    sender: self.penButton,
                    preferredSize: PencilSettingDetailView.preferredSize
                )
                self.showDetailPiker?(info)
                return
            }

            self.deselectToolButtons()
            self.pencilButton.isSelected = true
        }
        .disposed(by: disposeBag)

        eraseButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.eraseButton.isSelected == false else { return }
            self.deselectToolButtons()
            self.eraseButton.isSelected = true
        }
        .disposed(by: disposeBag)

        lassoButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.lassoButton.isSelected == false else { return }
            self.deselectToolButtons()
            self.lassoButton.isSelected = true
        }
        .disposed(by: disposeBag)

        colorButton.tap.bind { [weak self] in
            guard let self = self else { return }
            self.showColorPicker?(self.currentColor)
        }
        .disposed(by: disposeBag)
    }

}

// MARK: - Button event

extension PencilSettingView {

    func deselectToolButtons() {
        toolButtons.forEach { $0.isSelected = false }
    }

}

