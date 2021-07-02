//
//  DrawingContentView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/18.
//

import UIKit
import PencilKit
import RxSwift

class DrawingContentView: UIView, Undoable {
    private let disposeBag = DisposeBag()
    let canvas = PKCanvasView()
    let currentToolSubject = BehaviorSubject<DYDrawTool?>(value: nil)
    var shouldMakeTextField = false
    var didEndCreateTextField: (() -> Void)?

    init() {
        super.init(frame: .zero)
        initView()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if shouldMakeTextField {
            shouldMakeTextField = false
            createTextField(targetPoint: point)
            didEndCreateTextField?()
        }
        return super.point(inside: point, with: event)
    }

    private func initView() {
        canvas.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            canvas.drawingPolicy = .anyInput
        } else {
            canvas.allowsFingerDrawing = true
        }
        addSubViewPinEdge(canvas)
    }

    private func bindEvent() {
        currentToolSubject.bind { [weak self] tool in
            guard let pkTool = tool?.pkTool else {
                self?.canvas.isUserInteractionEnabled = false
                return
            }
            self?.canvas.isUserInteractionEnabled = true
            self?.canvas.tool = pkTool
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Init Items

extension DrawingContentView {

    // 최초 생성
    func createTextField(targetPoint: CGPoint) {
        let id = DYTestData.shared.textFieldIdToCreate
        DYTestData.shared.increaseTextFieldID()

        let viewModel = DYFlexibleTextFieldViewModel(id: id)
        let textField = DYFlexibleTextField(viewModel: viewModel)
        textField.center = targetPoint

        addSubviewWithUndoManager(textField)
    }

    func createImageSticker(image: UIImage, currentPage: Int = 0) {
        // TODO: 사용자 사진 ID 룰 정의
        let id = "test user image id"
        setStreachableView(id: id, image: image, currentPage: currentPage)
    }

    func createSticker(image: UIImage, currentPage: Int = 0) {
        // TODO: 스티커 ID 룰 정의
        let id = "test sticker image id"
        setStreachableView(id: id, image: image, currentPage: currentPage)
    }

    private func setStreachableView( id: String, image: UIImage, currentPage: Int) {
        // TODO: - 속지에서 superview의 스케일때문에 센터가 잘 안맞는 것 같은데 종상이형이 한번 손봐주면 좋을 것 같습니다.
        let calcedCenter = CGPoint(x: center.x, y: center.y * CGFloat(currentPage + 1))
        let imageView = UIImageView(image: image)
        let imageRatio = image.size.height / image.size.width
        let defaultImageWith: CGFloat = DYImageSizeStretchableView.defaultImageWidth
        let calcedImageHeight: CGFloat = imageRatio * DYImageSizeStretchableView.defaultImageWidth
        imageView.frame.size = CGSize(width: defaultImageWith, height: calcedImageHeight)

        let stickerView = DYImageSizeStretchableView(contentView: imageView)
        stickerView.enableClose = true
        stickerView.enableRotate = true
        stickerView.enableHStretch = true
        stickerView.enableWStretch = true
        stickerView.center = calcedCenter
        addSubviewWithUndoManager(stickerView)
    }
}

// MARK: - Retrieve Items

extension DrawingContentView {
    func setDrawData(_ drawData: Data) {
        let decoder = JSONDecoder()
        if let drawing = try? decoder.decode(PKDrawing.self, from: drawData) {
            canvas.drawing = drawing
        }
    }

    func setItems(_ items: [DecorationItem]) {
        items.forEach { item in
            if let textItem = item as? DecorationTextFieldItem {
                let viewModel = DYFlexibleTextFieldViewModel(id: item.id)
                let textField = DYFlexibleTextField(viewModel: viewModel)
                textField.viewModel.set(textItem)
                addSubview(textField)
            }

            if let imageItem = item as? DecorationImageItem {
                let imageStretchableView = DYImageSizeStretchableView(model: imageItem)
                addSubview(imageStretchableView)
            }
        }

    }
}

// MARK: - Get Items

extension DrawingContentView {
    func getItems(diaryID: String) -> [DecorationItem] {
        let items: [DecorationItem] = subviews.compactMap { subview in
            if let textField = subview as? DYFlexibleTextField {
                return textField.toItem(parentId: diaryID)
            }

            if let imageStrectchView = subview as? DYImageSizeStretchableView {
                // TODO: - 유저 이미지 스티커 ID 룰 정의
                return imageStrectchView.toItem(id: "", parentId: diaryID)
            }

            return nil
        }
        return items
    }
}
