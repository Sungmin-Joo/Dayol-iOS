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

class MonthlyCalendarView: BasePaper {
    private var containerViewLeft = NSLayoutConstraint()
    private var containerViewRight = NSLayoutConstraint()
    private let disposeBag = DisposeBag()
    
    let showDatePicker = PublishSubject<Void>()
    
    private let headerView: MonthlyCalendarHeaderView = {
        let header = MonthlyCalendarHeaderView(month: .january)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.isUserInteractionEnabled = true

        return header
    }()
    
    private let collectionView: MonthlyCalendarCollectionView = {
        let collectionView = MonthlyCalendarCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func configure(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        super.configure(viewModel: viewModel, paperStyle: paperStyle)
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
        setupConstraints()
        
        bind()
    }

    private func setupConstraints() {
        guard let paperStyle = self.paperStyle else { return }
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
                self.headerView.month = dateModel.month
            })
            .disposed(by: disposeBag)

        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedHeaderView(_:))))
    }
    
    @objc
    private func didTappedHeaderView(_ sender: MonthlyCalendarHeaderView) {
        showDatePicker.onNext(())
    }
}
