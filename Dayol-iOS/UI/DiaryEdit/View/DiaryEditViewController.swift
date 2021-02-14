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
    
    // MARK: - Private Properties
    
    private let disposeBag = DisposeBag()
    private let leftButton = DYNavigationItemCreator.barButton(type: .back)
    private let rightButton = DYNavigationItemCreator.barButton(type: .done)
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let toolBar = DYNavigationItemCreator.drawingFunctionToolbar()
    private let titleView = DYNavigationItemCreator.editableTitleView("새 다이어리")
    private let viewModel = DiaryEditViewModel()
    private var currentCoverColor: DiaryCoverColor = .DYBrown
    private var didCreatePassword: Observable<String>?
    
    // MARK: - UI Components
    
    private let diaryEditToggleView: DiaryEditToggleView = {
        let view = DiaryEditToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let diaryEditCoverView: DiaryEditCoverView = {
        let view = DiaryEditCoverView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let diaryEditPaletteView: DiaryEditColorPaletteView = {
        let view = DiaryEditColorPaletteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
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
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] show in
                self?.diaryEditCoverView.setDayolLogoHidden(!show)
            })
            .disposed(by: disposeBag)
    }
    
    private func colorBind() {
        diaryEditPaletteView.changedColor
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
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
                
                self.titleView.isEditting = false
                
                self.showPasswordViewController()
            }
            .disposed(by: disposeBag)
        
        titleView.editButton.rx.tap
            .bind { [weak self] in
                self?.titleView.isEditting = true
            }
            .disposed(by: disposeBag)

        toolBar.photoButton.rx.tap
            .bind { [weak self] in
                self?.showPicker()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Password ViewController Subjects

private extension DiaryEditViewController {
    func showPasswordViewController() {
        let passwordViewController = PasswordViewController(type: .new, diaryColor: self.currentCoverColor)
        bindDidCreatePassword(passwordViewController)
        self.present(passwordViewController, animated: true, completion: nil)
    }
    
    func bindDidCreatePassword(_ viewController: PasswordViewController) {
        viewController.didCreatePassword
            .subscribe(onNext: { [weak self] password in
                guard let self = self else { return }
                guard let title = self.titleView.titleLabel.text else { return }
                
                let diaryCoverModel = DiaryCoverModel(coverColor: self.currentCoverColor, title: title, totalPage: 0, password: password)
                self.viewModel.createDiaryInfo(model: diaryCoverModel)
                
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}
