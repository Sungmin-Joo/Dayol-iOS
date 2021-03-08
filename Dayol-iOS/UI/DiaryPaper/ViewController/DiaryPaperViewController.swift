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
    private let viewModel: DiaryPaperViewModel
    private var innerModels: [DiaryInnerModel]?
    
    // MARK: - UI Component
    
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .backWhite)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let toolBar = DYNavigationItemCreator.functionToolbar()
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let paperPresentView: PaperPresentView
    
    // MARK: - Init
    
    init(viewModel: DiaryPaperViewModel) {
        self.viewModel = viewModel
        // TODO: - 아직 스크롤 뷰 미구현이라 데모 용 첫 번째 속지만 노출
        self.paperPresentView = PaperPresentView(paperStyle: .vertical)
        self.paperPresentView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bind()
    }
    
    private func initView() {
        view.backgroundColor = .white
        view.addSubview(emptyView)
        // TODO: - 아직 스크롤 뷰 미구현이라 데모 용 첫 번째 속지만 노출
        view.addSubview(paperPresentView)

        setupNavigationBars()
        setConstraint()
    }
    
    private func setupNavigationBars() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barLeftItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barRightItem)
        
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
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
            // TODO: - 아직 스크롤 뷰 미구현이라 데모 용 첫 번째 속지만 노출
            paperPresentView.topAnchor.constraint(equalTo: view.topAnchor),
            paperPresentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paperPresentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            paperPresentView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    // MARK: - Bind
    
    private func bind() {
        bindTitle()
        bindEvent()
        bindPaperModel()
    }
    
    private func bindTitle() {
        viewModel.title
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] titleValue in
                let titleView = DYNavigationItemCreator.titleView(titleValue, color: .white)
                self?.navigationItem.titleView = titleView
            })
            .disposed(by: disposeBag)
    }

    private func bindPaperModel() {
        viewModel.paperList
            .observeOn(MainScheduler.instance)
            .filter({ [weak self] inners -> Bool in
                let shouldShowDiaryPeper = !inners[0].paperList.isEmpty
                
                self?.emptyView.isHidden = (shouldShowDiaryPeper == true)
                
                return shouldShowDiaryPeper
            })
            .subscribe(onNext: { [weak self] inners in
                let paperModel = inners[0].paperList[0]
                let paper = PaperProvider.createPaper(paperType: paperModel.paperType,
                                                      paperStyle: paperModel.paperStyle,
                                                      drawModel: paperModel.drawModelList)
                self?.innerModels = inners
                self?.paperPresentView.addPage(paper)
            })
            .disposed(by: disposeBag)
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

    @objc
    private func didTapEmptyView() {
        presentPaperModal(toolType: .add)
    }

    private func presentPaperModal(toolType: PaperModalViewController.PaperToolType) {
        guard let paperList = innerModels?[0].paperList else { return }
        
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let modalHeight: CGFloat = screenHeight - Design.addPageModalTopMargin
        let modalStyle: DYModalConfiguration.ModalStyle = isPadDevice ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let papers = paperList.compactMap {
            PaperModalModel.PaperListCellModel(id: $0.id,
                                               isStarred: false,
                                               paperStyle: $0.paperStyle,
                                               paperType: $0.paperType)
        }
        let addPageVC = PaperModalViewController(toolType: toolType, configure: configuration, papers: papers)
        presentCustomModal(addPageVC)
    }
}
