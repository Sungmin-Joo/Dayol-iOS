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

class MonthlyCalendarView: UIView {
    private var iPadOrientation: Design.IPadOrientation {
        if self.frame.size.width < self.frame.size.height {
            return .portrait
        } else {
            return .landscape
        }
    }
    
    let headerView: MonthlyCalendarHeaderView = {
        let header = MonthlyCalendarHeaderView(month: .january)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(headerView)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leftAnchor.constraint(equalTo: leftAnchor),
            headerView.rightAnchor.constraint(equalTo: rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Design.headerHeight(orientation: iPadOrientation))
        ])
    }
}
