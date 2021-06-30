//
//  DiaryPaperEditViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit
import RxSwift

class DiaryPaperEditViewController: DiaryPaperViewController {

    private enum Text: String {
        case editTitle = "edit_memo_title"
        
        var stringValue: String {
            return self.rawValue.localized
        }
    }

    // MARK: - UI Components
    
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let titleView = DYNavigationItemCreator.titleView(Text.editTitle.stringValue)

    // MARK: - Init
    
    init(viewModel: DiaryPaperViewModel) {
        super.init(index: 0, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        drawingContentView.isUserInteractionEnabled = true
    }

    override func didTapTextButton() {
        drawingContentView.currentToolSubject.onNext(nil)
        // TODO: - 탭 한 부분에 텍스트 필드를 생성하는 로직 추가
        // let convertedCenter = view.convert(view.center, to: diaryEditCoverView.diaryView)
        let convertedCenter = CGPoint(x: drawingContentView.bounds.maxX / 2.0, y: drawingContentView.bounds.maxY / 2.0)
        drawingContentView.createTextField(targetPoint: convertedCenter)
    }

    override func didEndPhotoPick(_ image: UIImage) {
        drawingContentView.createImageSticker(image: image)
    }

    override func didEndStickerPick(_ image: UIImage) {
        drawingContentView.createSticker(image: image)
    }
    
    // MARK: - Setup
    
    private func setupNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.titleView = titleView
        
        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
        
        leftButton.addTarget(self, action: #selector(dismissWithNoAnimation), for: .touchUpInside)
    }
    
    @objc
    private func dismissWithNoAnimation() {
        self.dismiss(animated: false, completion: nil)
    }

}
