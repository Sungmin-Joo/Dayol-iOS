//
//  DiaryEditViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/29.
//

import UIKit
import RxCocoa
import RxSwift

private enum Design {
    static let paletteHeight: CGFloat = 50
}

class DiaryEditViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let diaryEditToggleView: DiaryEditToggleView = {
        let view = DiaryEditToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let diaryEditCoverView: DiaryEditCoverView = {
        let view = DiaryEditCoverView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let diaryEditPaletteView: DiaryEditColorPaletteView = {
        let view = DiaryEditColorPaletteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        setupNavigationBar()
        initView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            diaryEditCoverView.setCoverSize(type: .medium)
        } else {
            diaryEditCoverView.setCoverSize(type: .big)
        }
    }
    
    private func initView() {
        view.addSubview(diaryEditToggleView)
        view.addSubview(diaryEditCoverView)
        view.addSubview(diaryEditPaletteView)
        
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            diaryEditToggleView.leftAnchor.constraint(equalTo: view.leftAnchor),
            diaryEditToggleView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryEditToggleView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            diaryEditCoverView.topAnchor.constraint(equalTo: diaryEditToggleView.bottomAnchor),
            diaryEditCoverView.bottomAnchor.constraint(equalTo: diaryEditPaletteView.topAnchor),
            diaryEditCoverView.leftAnchor.constraint(equalTo: view.leftAnchor),
            diaryEditCoverView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            diaryEditPaletteView.leftAnchor.constraint(equalTo: view.leftAnchor),
            diaryEditPaletteView.rightAnchor.constraint(equalTo: view.rightAnchor),
            diaryEditPaletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diaryEditPaletteView.heightAnchor.constraint(equalToConstant: Design.paletteHeight)
        ])
    }
    
    private func setupNavigationBar() {
        let leftButton = DYNavigationItemCreator.barButton(type: .back)
        let rightButton = DYNavigationItemCreator.barButton(type: .done)
        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBar = DYNavigationItemCreator.drawToolbar()
        let title = DYNavigationItemCreator.editableTitleView("다이어리")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.titleView = title

        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
        leftButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind { [weak self] in
                title.isEditting = false
            }
            .disposed(by: disposeBag)
        
        title.editButton.rx.tap
            .bind { [weak self] in
                title.isEditting = true
            }
            .disposed(by: disposeBag)
    }
}
