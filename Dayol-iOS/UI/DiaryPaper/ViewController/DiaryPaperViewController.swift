//
//  DiaryPaperViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/07.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let addPageModalTopMargin: CGFloat = 57.0
}

class DiaryPaperViewController: UIViewController {
    // MARK: - Properties
    
    typealias PaperModel = DiaryInnerModel.PaperModel
    
    private let disposeBag = DisposeBag()
    private let diaryCoverModel: DiaryCoverModel
    private(set) var diaryInnerModel: DiaryInnerModel
    
    // MARK: - UI Component
    
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .backWhite)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let titleView = DYNavigationItemCreator.titleView("", color: .white)
    private let toolBar = DYNavigationItemCreator.functionToolbar()
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    
    init(diaryCover: DiaryCoverModel, diaryInner: DiaryInnerModel) {
        self.diaryCoverModel = diaryCover
        self.diaryInnerModel = diaryInner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindEvent()
    }
    
    private func initView() {
        view.backgroundColor = .white
        view.addSubview(emptyView)

        setupNavigationBars()
        setConstraint()
    }
    
    private func setupNavigationBars() {
        titleView.titleLabel.text = diaryCoverModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barLeftItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barRightItem)
        navigationItem.titleView = titleView
        
        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
        
        barLeftItem.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func bindEvent() {
        barLeftItem.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        toolBar.pageButton.rx.tap
            .bind { [weak self] in
                self?.presentPaperModal(toolType: .list)
            }
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(didTapEmptyView))
        emptyView.addGestureRecognizer(tapGesture)
    }

    @objc func didTapEmptyView() {
        presentPaperModal(toolType: .add)
    }

    private func presentPaperModal(toolType: PaperModalViewController.PaperToolType) {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let modalHeight: CGFloat = screenHeight - Design.addPageModalTopMargin
        let modalStyle: DYModalConfiguration.ModalStyle = isPadDevice ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let papers = diaryInnerModel.paperList.map {
            PaperModalModel.PaperListCellModel(id: $0.id,
                                               isStarred: false,
                                               paperStyle: $0.paperStyle,
                                               paperType: $0.paperType)
        }
        let addPageVC = PaperModalViewController(toolType: toolType, configure: configuration, papers: papers)
        presentCustomModal(addPageVC)
    }
}
