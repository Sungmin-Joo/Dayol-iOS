//
//  MonthlyCalendarView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/25.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static func headerHeight(style: PaperStyle) -> CGFloat {
        switch style {
        case .vertical:
            return 125
        case .horizontal:
            return 81
        }
    }
}

class MonthlyCalendarView: UITableViewCell, PaperDescribing {
    private var containerViewLeft = NSLayoutConstraint()
    private var containerViewRight = NSLayoutConstraint()
    private let disposeBag = DisposeBag()
    var viewModel: PaperViewModel
    var paperStyle: PaperStyle

    private let headerView: MonthlyCalendarHeaderView = {
        let header = MonthlyCalendarHeaderView(month: .january)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    private let collectionView: MonthlyCalendarCollectionView = {
        let collectionView = MonthlyCalendarCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    init(viewModel: MonthlyCalendarViewModel = MonthlyCalendarViewModel(), paperStyle: PaperStyle) {
        self.viewModel = MonthlyCalendarViewModel()
        self.paperStyle = paperStyle
        super.init(style: .default, reuseIdentifier: MonthlyCalendarView.className)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(headerView)
        addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Design.headerHeight(style: paperStyle)),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func bind() {
        guard let viewModel = self.viewModel as? MonthlyCalendarViewModel else { return }
        viewModel.dateModel(date: Date())
            .subscribe(onNext: { [weak self] dateModel in
                guard let self = self else { return }
                let _ = dateModel.month
                let days = dateModel.days
                self.collectionView.days = days
            })
            .disposed(by: disposeBag)
    }
}
