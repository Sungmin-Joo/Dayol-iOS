//
//  DrawToolBar.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/07/20.
//

import UIKit
import RxSwift

private enum Design {
    static let headerAreaHeight: CGFloat = 56.0
    static let shadowColor = UIColor(white: 0, alpha: 0.15)
    static let cornerRadius: CGFloat = 15.0
    static let downButtonRightMargin: CGFloat = 20.0
    static let downButton = Assets.Image.Modal.down
}

private enum Text {
    static var penTitle: String {
        return "edit_pen_title".localized
    }
}

class DrawToolBar: UIView {

    var showColorPicker: ((UIColor) -> ())? {
        set { pencilSettingView.showColorPicker = newValue }
        get { pencilSettingView.showColorPicker }
    }
    var showDetailPiker: ((PencilSettingView.DetailViewInfo) -> Void)? {
        set { pencilSettingView.showDetailPiker = newValue }
        get { pencilSettingView.showDetailPiker }
    }
    var dismissAction: (() -> Void)?
    var currentToolsSubject: PublishSubject<DYPKTools> {
        return pencilSettingView.currentToolsSubject
    }

    // MARK: - UI Property
    private let headerArea: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Design.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray400
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        let title = Text.penTitle
        let attributedString = NSAttributedString.build(
            text: title,
            font: .boldSystemFont(ofSize: 18),
            align: .center,
            letterSpacing: -0.7,
            foregroundColor: .gray900
        )
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let downButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.downButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let pencilSettingView: PencilSettingView
    private let containerView: UIView = {
        let view = UIView()
        view.layer.setZepplinShadow(x: 0, y: -2, blur: 4, color: Design.shadowColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(pkTools: DYPKTools) {
        self.pencilSettingView = PencilSettingView(pkTools: pkTools)
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DrawToolBar {

    func setupSubviews() {
        downButton.addTarget(self, action: #selector(didTapDownButton), for: .touchUpInside)
        headerArea.addSubview(titleLabel)
        headerArea.addSubview(downButton)
        headerArea.addSubview(lineView)
        containerView.addSubview(headerArea)

        pencilSettingView.translatesAutoresizingMaskIntoConstraints = false
        pencilSettingView.backgroundColor = .white
        containerView.addSubview(pencilSettingView)

        addSubview(containerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // header
            headerArea.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerArea.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerArea.heightAnchor.constraint(equalToConstant: Design.headerAreaHeight),

            titleLabel.centerYAnchor.constraint(equalTo: headerArea.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerArea.centerXAnchor),

            downButton.centerYAnchor.constraint(equalTo: headerArea.centerYAnchor),
            downButton.rightAnchor.constraint(equalTo: headerArea.rightAnchor,
                                              constant: -Design.downButtonRightMargin),

            lineView.heightAnchor.constraint(equalToConstant: 1.0),
            lineView.leadingAnchor.constraint(equalTo: headerArea.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: headerArea.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: headerArea.bottomAnchor),

            // contents
            pencilSettingView.topAnchor.constraint(equalTo: headerArea.bottomAnchor),
            pencilSettingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pencilSettingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pencilSettingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc func didTapDownButton() {
        dismissAction?()
    }

}
