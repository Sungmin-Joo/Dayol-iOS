//
//  DiaryEditViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/29.
//

import UIKit
import RxCocoa
import RxSwift

class DiaryEditViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // TODO: Code For Test. Plz remove after making certain spec
        let leftButton = DYNavigationItemCreator.barButton(type: .back)
        let rightButton = DYNavigationItemCreator.barButton(type: .done)
        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBar = DYNavigationItemCreator.functionToolbar()
        let title = DYNavigationItemCreator.editableTitleView("다이어리다!")
        
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
                print("rightButton")
                title.isEditting = false
            }
            .disposed(by: disposeBag)
        
        title.editButton.rx.tap
            .bind { [weak self] in
                title.isEditting = true
            }
            .disposed(by: disposeBag)
        
        title.textView.rx.didEndEditing
            .bind { [weak self] in
                title.isEditting = false
            }
            .disposed(by: disposeBag)
    }
}
