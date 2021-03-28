//
//  DiaryPaperEditViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit
import Combine

class DiaryPaperEditViewController: DiaryPaperViewController {
    
    // MARK: - Private Properties
    
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let toolBar = DYNavigationItemCreator.drawingFunctionToolbar()
    private let titleView = DYNavigationItemCreator.titleView("메모 편집")
    
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
    }
    
    // MARK: - Setup
    
    private func setupNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.titleView = titleView
        
        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
        
        leftButton.addTarget(self, action: #selector(popWithAnimation), for: .touchUpInside)
        toolBar.stickerButton.addTarget(self, action: #selector(presentStickerModal), for: .touchUpInside)
    }
    
    @objc
    private func popWithAnimation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func presentStickerModal() {
        let stickerModal = StickerModalViewContoller()
        self.presentCustomModal(stickerModal)
        
        stickerModal.didTappedSticker
            .sink { _ in
                // Some Error
            } receiveValue: { stickerImage in
                let imageView = UIImageView(image: stickerImage)
                imageView.frame = CGRect(x: 0, y: 0, width: 76.0, height: 66.0)
                let stickerView = DYStickerSizeStretchableView(contentView: imageView)
                stickerView.alpha = 0.0
                stickerView.enableClose = true
                stickerView.enableRotate = true
                stickerView.enableHStretch = true
                stickerView.enableWStretch = true
                
                self.paper.addSubview(stickerView)
                
                stickerView.center = self.view.center
                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    stickerView.alpha = 1.0
                }, completion: nil)
            }
            .store(in: &cancellable)

    }
}
