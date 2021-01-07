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
    case ipad(UIDeviceOrientation)
    case iphone
    
    var emptyTop: CGFloat {
        switch self {
        case .iphone:
            return 77
        case .ipad(let orientation):
            if orientation == .portrait {
                return 56
            } else {
                return 128
            }
        }
    }
    
    var emptyBottom: CGFloat {
        switch self {
        case .iphone:
            return 84
        case .ipad(let orientation):
            if orientation == .portrait {
                return 61
            } else {
                return 134
            }
        }
    }
}

class DiaryPaperViewController: UIViewController {
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .back)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let titleView = DYNavigationItemCreator.titleView("TESTTEST")
    private let toolBar = DYNavigationItemCreator.functionToolbar()
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private var design: Design {
        if isPadDevice {
            return .ipad(UIDevice.current.orientation)
        } else {
            return .iphone
        }
    }
    
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraint()
    }
    
    private func initView() {
        view.backgroundColor = .white
        view.addSubview(emptyView)
        setupNavigationBars()
        setConstraint()
    }
    
    private func setupNavigationBars() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barLeftItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barRightItem)
        navigationItem.titleView = titleView
        
        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        emptyView.setConstraint(top: design.emptyTop, bottom: design.emptyBottom)
    }
}
