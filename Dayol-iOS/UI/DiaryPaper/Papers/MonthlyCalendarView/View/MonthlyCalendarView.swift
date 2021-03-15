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
    enum IPadOrientation {
        case landscape
        case portrait
    }
    case ipad
    case iphone
    
    static var current: Design = { isPadDevice ? .ipad : iphone }()
    
    static func headerHeight(orientation: IPadOrientation) -> CGFloat {
        switch current {
        case .iphone:
            return 69
        case .ipad:
            if orientation == .portrait {
                return 125
            } else {
                return 81
            }
        }
    }
}

class MonthlyCalendarView: BasePaper {
    private var containerViewLeft = NSLayoutConstraint()
    private var containerViewRight = NSLayoutConstraint()
    
    private var iPadOrientation: Design.IPadOrientation {
        if self.frame.size.width > self.frame.size.height {
            return .landscape
        } else {
            return .portrait
        }
    }
    
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
        super.init(viewModel: viewModel, paperStyle: paperStyle)
        self.viewModel = MonthlyCalendarViewModel()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        super.initView()
        drawArea.addSubview(headerView)
        drawArea.addSubview(collectionView)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: drawArea.topAnchor),
            headerView.leftAnchor.constraint(equalTo: drawArea.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: drawArea.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Design.headerHeight(orientation: iPadOrientation)),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: drawArea.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: drawArea.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: drawArea.bottomAnchor)
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
