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
    
    static func collectionLeft(orientation: IPadOrientation) -> CGFloat {
        switch current {
        case .iphone:
            return 0
        case .ipad:
            if orientation == .portrait {
                return 77
            } else {
                return 0
            }
        }
    }
    
    static func collectionRight(orientation: IPadOrientation) -> CGFloat {
        switch current {
        case .iphone:
            return 0
        case .ipad:
            if orientation == .portrait {
                return 77
            } else {
                return 0
            }
        }
    }
}

class MonthlyCalendarView: UIView {
    private var containerViewLeft = NSLayoutConstraint()
    private var containerViewRight = NSLayoutConstraint()
    private var iPadOrientation: Design.IPadOrientation {
        if self.frame.size.width > self.frame.size.height {
            return .landscape
        } else {
            return .portrait
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContainerView()
    }
    
    private func initView() {
        addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(collectionView)
        setConstraint()
    }
    
    private func setConstraint() {
        containerViewLeft = containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.collectionLeft(orientation: iPadOrientation))
        containerViewRight = containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Design.collectionRight(orientation: iPadOrientation))
        
        NSLayoutConstraint.activate([
            containerViewLeft, containerViewRight,
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Design.headerHeight(orientation: iPadOrientation)),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func updateContainerView() {
        containerViewLeft.constant = Design.collectionLeft(orientation: iPadOrientation)
        containerViewRight.constant = -Design.collectionRight(orientation: iPadOrientation)
    }
}
