//
//  DiaryPaperEditViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit
import RxSwift

class DiaryPaperEditViewController: DiaryPaperViewController, Drawable {
    private enum Text: String {
        case editTitle = "edit_memo_title"
        
        var stringValue: String {
            return self.rawValue.localized
        }
    }

    var currentTool: DYNavigationDrawingToolbar.ToolType?
    var currentEraseTool: DYEraseTool = DYEraseTool(isObjectErase: false)
    var currentPencilTool: DYPencilTool = DYPencilTool(color: .black, isHighlighter: false)
    
    // MARK: - UI Components
    
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let titleView = DYNavigationItemCreator.titleView(Text.editTitle.stringValue)
    let toolBar = DYNavigationItemCreator.drawingFunctionToolbar()

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
        bindToolBarEvent()
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
