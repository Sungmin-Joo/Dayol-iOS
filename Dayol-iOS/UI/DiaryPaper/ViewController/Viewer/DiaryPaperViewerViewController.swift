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
    static var addScheduleTitle: String { "속지 또는 일정 등록" }
    static var addScheduleDesc: String { "선택한 날짜에 새로운 일정을 등록하거나 작성한 속지를 연결할 수 있습니다" }
    static var addScheduleAddButton: String { "일정추가" }
    static var addScheduleLinkButton: String { "속지연결" }
}

class DiaryPaperViewerViewController: UIViewController {
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var cancellable = [Cancellable]()
    private let viewModel: DiaryPaperViewerViewModel
    private var paperModels: [Paper]?
    
    var currentIndex: Int = -1
    
    // MARK: - UI Component
    
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .backWhite)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let toolBar = DYNavigationItemCreator.functionToolbar()
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private(set) var paperViewControllers: [DiaryPaperViewController]?
    
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
        let coverColor: PaletteColor = PaletteColor.find(hex: viewModel.coverHex) ?? .DYBrown

        navigationController?.navigationBar.barTintColor = coverColor.uiColor
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        super.viewWillDisappear(animated)
    }
    
    private func initView() {
        view.backgroundColor = .white
        setupPageViewController()
        setupNavigationBars()
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
        viewModel.paperList(diaryId: viewModel.diaryId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] papers in
                guard let self = self else { return }

                if papers.isEmpty {
                    let vc = DiaryPaperEmptyViewController()

                    vc.delegate = self
                    self.pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
                } else {
                    var diaryPaperViewControllers = [DiaryPaperViewController]()
                    self.paperModels = papers

                    for (index, paper) in papers.enumerated() {
                        let paperViewModel = DiaryPaperViewModel(paper: paper, numberOfPapers: Int(paper.pageCount))
                        let paperViewController = DiaryPaperViewController(index: index, viewModel: paperViewModel)

                        paperViewController.didReceivedEvent
                            .subscribe(onNext: { event in
                                switch event {
                                case .showDatePicker:
                                    self.presentPaperModal(toolType: .date)
                                case .showPaperSelect:
                                    self.presentPaperModal(toolType: .monthList)
                                case .showAddSchedule(date: let date):
                                    self.presentAddSchedule(date: date)
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
                }
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

                let paperEditViewController = DiaryPaperEditViewController(viewModel: viewModel)
                let nav = DYNavigationController(rootViewController: paperEditViewController)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve

                self?.present(nav, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

    private func presentPaperModal(toolType: PaperModalViewController.PaperToolType) {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let modalHeight: CGFloat = screenHeight - Design.addPageModalTopMargin
        let modalStyle: DYModalConfiguration.ModalStyle = isPadDevice ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let modalVC = PaperModalViewController(diaryId: viewModel.diaryId, toolType: toolType, configure: configuration)
        modalVC.delegate = self

        presentCustomModal(modalVC)
    }

    private func moveToPage(index: Int) {
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

    private func presentAddSchedule(date: Date) {
        let alert = DayolAlertController(title: Text.addScheduleTitle, message: Text.addScheduleDesc)
        alert.addAction(.init(title: Text.addScheduleLinkButton, style: .cancel, handler: {
            print("LinkButton")
        }))
        alert.addAction(.init(title: Text.addScheduleAddButton, style: .default, handler: { [weak self] in
            self?.presentPaperModal(toolType: .shedule(scheduleType: .monthly))
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension DiaryPaperViewerViewController {
    var currentViewController: DiaryPaperViewController? {
        return paperViewControllers?[safe: currentIndex];
    }
}

extension DiaryPaperViewerViewController: PaperModalViewDelegate {
    func didTappedItem(_ paper: Paper) {
        guard let index = paperModels?.firstIndex(where: { $0.id == paper.id }) else { return }
        moveToPage(index: index)
    }
    
    func didTappedAdd() {
        presentPaperModal(toolType: .add)
    }

    func didTappedMonthlyAdd() {
        presentPaperModal(toolType: .date)
    }

    func didSelectedDate(didSelected date: Date?) {
        guard let currentVC = currentViewController, let pickedDate = date else { return }
        let orientaion = currentVC.paper.orientaion

        viewModel.addPaper(.monthly(date: pickedDate), orientation: orientaion)
    }
}

extension DiaryPaperViewerViewController: DiaryPaperEmptyViewControllerDelegate {
    func didTapEmptyView() {
        presentPaperModal(toolType: .add)
    }
}
