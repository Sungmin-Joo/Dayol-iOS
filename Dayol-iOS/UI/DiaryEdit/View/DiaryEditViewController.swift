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

class DiaryEditViewController: DYDrawableViewController {

    // MARK: - Private Properties

    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let viewModel = DiaryEditViewModel()
    private var currentCoverColor: DiaryCoverColor = .DYBrown

    // MARK: - UI Components

    private let titleView = DYNavigationItemCreator.editableTitleView("새 다이어리")
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private let rightButton = DYNavigationItemCreator.barButton(type: .done)
    private let diaryEditToggleView: DiaryEditToggleView = {
        let view = DiaryEditToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let diaryEditPaletteView: DefaultColorCollectionView = {
        let view = DefaultColorCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    let diaryEditCoverView: DiaryEditCoverView = {
        let view = DiaryEditCoverView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        delegate = self
        setupNavigationBar()
        initView()
    }
    
    // MARK: - Setup Method
    
    private func initView() {
        view.addSubview(diaryEditToggleView)
        view.addSubview(diaryEditCoverView)
        view.addSubview(diaryEditPaletteView)
        diaryEditPaletteView.colors = viewModel.diaryColors
        setConstraint()
        setupGesture()
        
        bind()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.titleView = titleView

        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
    }
    
    // MARK: - Bind
    
    private func bind() {
        colorBind()
        navigationBind()
        switchBind()
    }
    
    private func switchBind() {
        diaryEditToggleView.changedSwitch
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] show in
                self?.diaryEditCoverView.setDayolLogoHidden(!show)
            })
            .disposed(by: disposeBag)
    }
    
    private func colorBind() {
        diaryEditPaletteView.changedColor
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] DYCoverColor in
                guard let self = self else { return }
                self.diaryEditCoverView.setCoverColor(color: DYCoverColor)
                self.currentCoverColor = DYCoverColor
            })
            .disposed(by: disposeBag)
    }
    
    private func navigationBind() {
        leftButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.hideKeyboard()
                
                self.showPasswordViewController()
            }
            .disposed(by: disposeBag)
        
        titleView.editButton.rx.tap
            .bind { [weak self] in
                self?.titleView.titleTextField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - Password ViewController Subjects

private extension DiaryEditViewController {
    func showPasswordViewController() {
        let passwordViewController = PasswordViewController(inputType: .new, diaryColor: self.currentCoverColor)
        bindDidCreatePassword(passwordViewController)
        present(passwordViewController, animated: true, completion: nil)
    }
    
    func bindDidCreatePassword(_ viewController: PasswordViewController) {
        viewController.didCreatePassword
            .subscribe(onNext: { [weak self] password in
                guard let self = self else { return }
                guard let title = self.titleView.titleLabel.text else { return }

                let diaryCoverModel = DiaryInfoModel(id: self.viewModel.diaryIdToCreate, color: self.currentCoverColor, title: title, totalPage: 0, password: password)
                self.viewModel.createDiaryInfo(model: diaryCoverModel)
                
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}

// MARK: - Keyboard Control

private extension DiaryEditViewController {

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func hideKeyboard() {
        // titleView 가 네비게이션 타이틀 바에 붙어있어서 직접 호출해줘야한다.
        titleView.endEditing(true)
        view.endEditing(true)
    }

}
