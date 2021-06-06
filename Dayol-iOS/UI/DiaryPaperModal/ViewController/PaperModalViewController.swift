//
//  PaperModalViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {

}

private enum Text {
    static var selectMonth: String { "Monthly 메모지 선택" }
}

protocol PaperModalViewDelegate: NSObject {
    func didTappedItem(_ index: PaperModel)
    func didTappedAdd()
    func didSelectedDate(didSelected date: Date?)
    func didTappedMonthlyAdd()
}

class PaperModalViewController: DYModalViewController {

    enum PaperToolType {
        case add
        case list
        case monthList
        case date
    }

    private let disposeBag = DisposeBag()
    private let diaryId: Int
    // MARK: - UI Property

    private lazy var addPaperHeaderView = AddPaperHeaderView()
    private lazy var addPaperContentView = AddPaperContentView()
    private lazy var paperListHeaderView = PaperListHeaderView()
    private lazy var paperListContentView = PaperListContentView()
    private lazy var monthltPageListHeaderView = MonthlyPaperListHeaderView()
    private lazy var monthlyPageListContentView = MonthlyPaperListContentView()
    private lazy var datePickerHeaderView = DatePickerHeaderView()
    private lazy var datePickerContentView = DatePickerView()

    public weak var delegate: PaperModalViewDelegate?

    var toolType: PaperToolType

    init(diaryId: Int, toolType: PaperToolType, configure: DYModalConfiguration) {
        self.diaryId = diaryId
        self.toolType = toolType
        super.init(configure: configure)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleArea()
        setupContentArea()
        bindEvent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        switch toolType {
        case .add:
            addPaperContentView.layoutCollectionView(width: size.width)
        case .list:
            paperListContentView.layoutCollectionView()
        case .monthList:
            monthlyPageListContentView.layoutCollectionView()
        case .date:
            datePickerContentView.setNeedsLayout()
        }

    }

    private func setupTitleArea() {
        switch toolType {
        case .add:
            titleView = addPaperHeaderView
        case .list:
            titleView = paperListHeaderView
        case .monthList:
            setupTitleLabel(Text.selectMonth)
            setupRightDownButton()
        case .date:
            titleView = datePickerHeaderView
        }
    }

    private func setupContentArea() {
        switch toolType {
        case .add:
            contentView = addPaperContentView
        case .list:
            contentView = paperListContentView
        case .monthList:
            contentView = monthlyPageListContentView
        case .date:
            contentView = datePickerContentView
        }
    }
}

private extension PaperModalViewController {

    func bindEvent() {
        switch toolType {
        case .add:
            bindAddPaperEvent()
        case .list:
            bindPaperListEvent()
        case .monthList:
            bindMonthListEvent()
        case .date:
            bindDatePickerEvent()
        }
    }

    func bindAddPaperEvent() {
        addPaperHeaderView.barLeftButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        addPaperHeaderView.barRightButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.addPaperContentView.viewModel.addPaper(diaryId: self.diaryId)
                })
            }
            .disposed(by: disposeBag)
    }

    func bindPaperListEvent() {
        paperListHeaderView.closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        paperListContentView.didSelectAddCell
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.delegate?.didTappedAdd()
                }
            })
            .disposed(by: disposeBag)

        paperListContentView.didSelectItem
            .subscribe(onNext: { [weak self] paper in
                self?.dismiss(animated: true) {
                    self?.delegate?.didTappedItem(paper)
                }
            })
            .disposed(by: disposeBag)
    }

    func bindDatePickerEvent() {
        var month: String? = ""
        var year: String? = ""
        Observable.combineLatest(datePickerContentView.didSelectYear, datePickerContentView.didSelectMonth)
            .subscribe(onNext: { selectedYear, selectedMonth in
                month = selectedMonth
                year = selectedYear
            })
            .disposed(by: disposeBag)

        datePickerHeaderView.didTappedConfirmButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let dateString = "\(year ?? "") \(month ?? "")"
                self.dismiss(animated: true) {
                    let date = DateFormatter.yearMonth.date(from: dateString)
                    self.delegate?.didSelectedDate(didSelected: date)
                }
            })
            .disposed(by: disposeBag)
    }

    func bindMonthListEvent() {
        monthlyPageListContentView.didSelect
            .subscribe(onNext: { [weak self] selectEvent in
                guard let self = self else { return }

                switch selectEvent {
                case .item(paper: let paper):
                    self.dismiss(animated: true) {
                        self.delegate?.didTappedItem(paper)
                    }
                case .add:
                    self.dismiss(animated: true) {
                        self.delegate?.didTappedMonthlyAdd()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
