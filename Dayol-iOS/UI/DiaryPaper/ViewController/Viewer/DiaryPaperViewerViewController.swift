//
//  DiaryPaperViewerViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/07.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

private enum Design {
    static let addPageModalTopMargin: CGFloat = 57.0
}

private enum Text {
    static var selectMonth: String { "Monthly 메모지 선택" }
}

class DiaryPaperViewerViewController: UIViewController {
    // MARK: - Properties
    
    typealias PaperModel = DiaryInnerModel.PaperModel
    
    private let disposeBag = DisposeBag()
    private var cancellable = [Cancellable]()
    private let viewModel: DiaryPaperViewerViewModel
    private var paperModels: [DiaryInnerModel.PaperModel]?
    
    var currentIndex: Int = -1
    
    // MARK: - UI Component
    
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .backWhite)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let toolBar = DYNavigationItemCreator.functionToolbar()
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private(set) var paperViewControllers: [DiaryPaperViewController]?
    
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: DiaryPaperViewerViewModel) {
        self.viewModel = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = viewModel.coverColor
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        super.viewWillDisappear(animated)
    }
    
    private func initView() {
        view.backgroundColor = .white
        view.addSubview(emptyView)
        setupPageViewController()
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
        ])
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    // MARK: - Bind
    
    private func bind() {
        bindTitle()
        bindEvent()
        bindPaperModel()
    }
    
    private func bindTitle() {
        viewModel.title
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] titleValue in
                let titleView = DYNavigationItemCreator.titleView(titleValue, color: .white)
                self?.navigationItem.titleView = titleView
            })
            .disposed(by: disposeBag)
    }

    private func bindPaperModel() {
        viewModel.paperList
            .observe(on: MainScheduler.instance)
            .filter({ [weak self] papers -> Bool in
                let shouldShowDiaryPaper = !papers.isEmpty
                
                self?.emptyView.isHidden = (shouldShowDiaryPaper == true)
                
                return shouldShowDiaryPaper
            })
            .subscribe(onNext: { [weak self] papers in
                guard let self = self, papers.isEmpty == false else { return }

                var diaryPaperViewControllers = [DiaryPaperViewController]()
                self.paperModels = papers
                
                for (index, paper) in papers.enumerated() {
                    let paperViewModel = DiaryPaperViewModel(paper: paper, numberOfPapers: paper.numberOfPapers)
                    let paperViewController = DiaryPaperViewController(index: index, viewModel: paperViewModel)

                    paperViewController.didReceivedEvent
                        .subscribe(onNext: { event in
                            switch event {
                            case .showDatePicker:
                                self.presentDatePickerModal()
                            case .showPaperSelect:
                                self.presentPaperSelectModal()
                            }
                        })
                        .disposed(by: self.disposeBag)

                    diaryPaperViewControllers.append(paperViewController)
                }
                self.paperViewControllers = diaryPaperViewControllers

                if self.currentIndex == -1 {
                    self.currentIndex = 0
                } else {
                    self.currentIndex = diaryPaperViewControllers.count - 1
                }

                self.pageViewController.setViewControllers([diaryPaperViewControllers[self.currentIndex]], direction: .forward, animated: true, completion: nil)
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

        toolBar.editButton.rx.tap
            .bind { [weak self] in
                guard let currentVC = self?.currentViewController else { return }
                let viewModel = currentVC.viewModel
                let paperEditViewController = DiaryPaperEditViewController.make(viewModel: viewModel)
                self?.present(paperEditViewController, animated: true, completion: nil)
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
        guard let paperModels = self.paperModels else { return }
        
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let modalHeight: CGFloat = screenHeight - Design.addPageModalTopMargin
        let modalStyle: DYModalConfiguration.ModalStyle = isPadDevice ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let papers = paperModels.compactMap {
            PaperModalModel.PaperListCellModel(id: $0.id,
                                               isStarred: false,
                                               paperStyle: $0.paperStyle,
                                               paperType: $0.paperType)
        }
        let modalVC = PaperModalViewController(toolType: toolType, configure: configuration, papers: papers)
        modalVC.delegate = self

        presentCustomModal(modalVC)
    }

    private func presentDatePickerModal() {
        let datePicker = DatePickerModalViewController()
        datePicker.delegate = self

        presentCustomModal(datePicker)
    }

    private func presentPaperSelectModal() {
        guard let paperType = currentViewController?.paperType else { return }
        let papers = viewModel.findModels(type: paperType)
        let viewModel = PaperSelectModalViewModel(paperModels: papers)
        let paperSelectModal = PaperSelectModalViewController(title: Text.selectMonth, viewModel: viewModel)

        paperSelectModal.delegate = self

        presentCustomModal(paperSelectModal)
    }
}

extension DiaryPaperViewerViewController {
    var currentViewController: DiaryPaperViewController? {
        return paperViewControllers?[safe: currentIndex];
    }
}

extension DiaryPaperViewerViewController: PaperModalViewDelegate {
    func didTappedItem(_ index: Int) {
        guard let selectedViewController = self.paperViewControllers?[safe: index], currentIndex != index else { return }
        let direction: UIPageViewController.NavigationDirection
        if currentIndex < index {
            direction = .forward
        } else {
            direction = .reverse
        }
        currentIndex = index
        self.pageViewController.setViewControllers([selectedViewController], direction: direction, animated: true, completion: nil)

    }
    
    func didTappedAdd() {
        presentPaperModal(toolType: .add)
    }
}

extension DiaryPaperViewerViewController: DatePickerModalViewControllerDelegate {
    func datePicker(_ datePicker: DatePickerModalViewController, didSelected date: Date?) {
        guard let currentVC = currentViewController, let pickedDate = date else { return }
        let paperStyle = currentVC.paper.style

        viewModel.addPaper(.monthly(date: pickedDate), style: paperStyle)
    }
}

extension DiaryPaperViewerViewController: PaperSelectCollectionViewControllerDelegate {
    func paperSelectCollectionViewDidSelectAdd() {
        print("add!!")
    }

    func paperSelectCollectionView(_ paperSelectCollectionView: PaperSelectModalViewController, didSelectItem: DiaryInnerModel.PaperModel) {
        print(didSelectItem)
    }
}
