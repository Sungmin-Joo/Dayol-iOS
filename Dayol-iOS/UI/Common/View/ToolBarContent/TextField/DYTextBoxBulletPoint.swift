//
//  DYTextBoxBulletPoint.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/01.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    enum CheckBox {
        enum Image {
            static let on = Assets.Image.DYTextField.CheckBox.on
            static let off = Assets.Image.DYTextField.CheckBox.off
        }

        static let size = CGSize(width: 18, height: 18)
    }

    enum Bullet {
        static let size = CGSize(width: 17, height: 17)
    }

}

class DYTextBoxBulletPoint: UIView {

    enum BulletType {
        case dot
        case checkBox(isSelected: Bool)
        case none

        static let BulletSize = CGSize(width: 18.0, height: 18.0)
    }

    private let disposeBag = DisposeBag()

    // MARK: UI

    private var dotView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Design.Bullet.size.width / 2.0
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var checkBox: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(Design.CheckBox.Image.off, for: .normal)
        button.setImage(Design.CheckBox.Image.on, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Init

    init() {
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: UI Update

    func updateAccessoryView(_ accessoryType: BulletType) {
        switch accessoryType {
        case .dot:
            dotView.isHidden = false
            checkBox.isHidden = true
        case .checkBox(let isSelected):
            dotView.isHidden = true
            checkBox.isHidden = false
            checkBox.isSelected = isSelected
        case .none:
            dotView.isHidden = false
            checkBox.isHidden = false
        }
    }
}

private extension DYTextBoxBulletPoint {

    func initView() {
        addSubview(dotView)
        addSubview(checkBox)

        checkBox.rx.tap.bind { [weak self] in
            self?.checkBox.isSelected.toggle()
        }
        .disposed(by: disposeBag)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dotView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dotView.widthAnchor.constraint(equalToConstant: Design.Bullet.size.width),
            dotView.heightAnchor.constraint(equalToConstant: Design.Bullet.size.height),

            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: Design.CheckBox.size.width),
            checkBox.heightAnchor.constraint(equalToConstant: Design.CheckBox.size.height),
        ])
    }
}
