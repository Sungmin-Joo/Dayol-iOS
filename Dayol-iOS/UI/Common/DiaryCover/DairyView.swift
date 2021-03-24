//
//  DairyView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit

private enum Design {
    enum Standard {
        static let width: CGFloat = 552.0
        static let lockerMargin: CGFloat = 16.0
        static let lockerSize = CGSize(width: 140, height: 120)
    }
}

class DiaryView: UIView {
    private let coverView = DiaryCoverView()
    private let lockerView = DiaryLockerView()

    private var lockerMarginConstraint: NSLayoutConstraint?
    private var lockerWidthConstraint: NSLayoutConstraint?
    private var lockerHeightConstraint: NSLayoutConstraint?

    var isLock: Bool = false {
        didSet {
            guard isLock else {
                lockerView.unlock()
                return
            }
            lockerView.lock()
        }
    }
	
	init() {
		super.init(frame: .zero)
		addSubview(coverView)
		addSubview(lockerView)
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        lockerView.translatesAutoresizingMaskIntoConstraints = false

		setConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func layoutSubviews() {
        typealias Const = Design.Standard
        super.layoutSubviews()
        let ratio = frame.width / Const.width
        lockerMarginConstraint?.constant = Const.lockerMargin * ratio
        lockerWidthConstraint?.constant = Const.lockerSize.width * ratio
        lockerHeightConstraint?.constant = Const.lockerSize.height * ratio
    }

	private func setConstraints() {
        typealias Const = Design.Standard
        let lockerMarginConstraint = lockerView.rightAnchor.constraint(equalTo: coverView.rightAnchor)
        let lockerWidthConstraint = lockerView.widthAnchor.constraint(equalToConstant: Const.lockerSize.width)
        let lockerHeightConstraint = lockerView.heightAnchor.constraint(equalToConstant: Const.lockerSize.height)
		NSLayoutConstraint.activate([
            coverView.leftAnchor.constraint(equalTo: leftAnchor),
            coverView.topAnchor.constraint(equalTo: topAnchor),
            coverView.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverView.rightAnchor.constraint(equalTo: rightAnchor),
            lockerView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),

            lockerMarginConstraint,
            lockerWidthConstraint,
            lockerHeightConstraint
		])

        self.lockerMarginConstraint = lockerMarginConstraint
        self.lockerWidthConstraint = lockerWidthConstraint
        self.lockerHeightConstraint = lockerHeightConstraint
	}
}

extension DiaryView {
    func setCover(color: DiaryCoverColor) {
        self.coverView.backgroundColor = color.coverColor
        self.lockerView.backgroundColor = color.lockerColor
    }
    
    func setDayolLogoHidden(_ isHidden: Bool) {
        self.coverView.setDayolLogoHidden(isHidden)
    }
}
