//
//  DairyView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/22.
//

import UIKit
import PencilKit
import RxSwift

private enum Design {
    enum Standard {
        static let width: CGFloat = 552.0
        static let lockerMargin: CGFloat = 16.0
        static let lockerSize = CGSize(width: 140, height: 120)
    }
}

class DiaryView: UIView, Undoable {
    private let disposeBag = DisposeBag()
    let didTappedLocker = PublishSubject<Void>()

    // MARK: - UI Properties

    private let coverView = DiaryCoverView()
    private let lockerView = DiaryLockerView()

    private var lockerMarginConstraint: NSLayoutConstraint?
    private var lockerWidthConstraint: NSLayoutConstraint?
    private var lockerHeightConstraint: NSLayoutConstraint?

    var drawingContentView = DrawingContentView()

    var hasLogo: Bool = false
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
        initView()
        setConstraints()
//        bindEvent()
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

    private func initView() {
        coverView.translatesAutoresizingMaskIntoConstraints = false
        lockerView.translatesAutoresizingMaskIntoConstraints = false


        addSubview(coverView)
        addSubViewPinEdge(drawingContentView)
        addSubview(lockerView)

        setupGetsture()
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

    private func setupGetsture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedLockerView))
        lockerView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func didTappedLockerView() {
        didTappedLocker.onNext(())
    }

}

extension DiaryView {
    func setCover(color: PaletteColor) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.coverView.backgroundColor = color.uiColor
            self.lockerView.backgroundColor = color.lockerColor
        }
    }
    
    func setDayolLogoHidden(_ isHidden: Bool) {
        hasLogo = (isHidden == false)
        coverView.setDayolLogoHidden(isHidden)
    }
}
//
//// MARK: - Create Items
//
//extension DiaryView {
//    // 최초 생성
//    func createTextField(diaryID: String, targetPoint: CGPoint) {
//        let id = DYTestData.shared.textFieldIdToCreate
//        DYTestData.shared.increaseTextFieldID()
//
//        let viewModel = DYFlexibleTextFieldViewModel(id: id)
//        let textField = DYFlexibleTextField(viewModel: viewModel)
//        textField.center = targetPoint
//
//        addSubviewWithUndoManager(textField)
//
//        let _ = textField.becomeFirstResponder()
//    }
//}
//
//// MARK: - Control Decoration Item
//
//extension DiaryView {
//
//    func set(model: Diary) {
//        setDrawingData(model.drawCanvas)
//        setItems(model.contents)
//    }
//
//    func getItems(diaryID: String) -> [DecorationItem] {
//        let items: [DecorationItem] = subviews.compactMap { subview in
//            if let textField = subview as? DYFlexibleTextField {
//                return textField.toItem(parentId: diaryID)
//            }
//
//            if let imageStrectchView = subview as? DYImageSizeStretchableView {
//                // TODO: - 유저 이미지 스티커 ID 룰 정의
//                return imageStrectchView.toItem(id: "", parentId: diaryID)
//            }
//
//            return nil
//        }
//        return items
//    }
//
//    private func setDrawingData(_ data: Data) {
//        let decoder = JSONDecoder()
//        if let drawing = try? decoder.decode(PKDrawing.self, from: data) {
//            canvas.drawing = drawing
//        }
//    }
//
//    private  func setItems(_ items: [DecorationItem]) {
//        items.forEach { item in
//            if let textItem = item as? DecorationTextFieldItem {
//                let viewModel = DYFlexibleTextFieldViewModel(id: item.id)
//                viewModel.set(textItem)
//                let textField = DYFlexibleTextField(viewModel: viewModel)
////                textField.viewModel.set(textItem)
//                addSubview(textField)
//            }
//
//            if let imageItem = item as? DecorationImageItem {
//                let imageStretchableView = DYImageSizeStretchableView(model: imageItem)
//                addSubview(imageStretchableView)
//            }
//        }
//    }
//
//}
