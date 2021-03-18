//
//  DiaryPaperViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/10.
//

import UIKit
import RxSwift
import RxCocoa

class DiaryPaperViewController: UIViewController {
    let index: Int
    let paper: PaperPresentView
    
    private var scaleForFit: CGFloat {
        switch Orientation.currentState {
        case .portrait:
            switch paper.paperStyle {
            case .vertical:
                return view.frame.height / paper.paperStyle.size.height
            case .horizontal:
                return view.frame.width / paper.paperStyle.size.width
            }
        case .landscape:
            switch paper.paperStyle {
            case .vertical:
                return view.frame.height / paper.paperStyle.size.height
            case .horizontal:
                return view.frame.width / paper.paperStyle.size.width
            }
        default: return 0.0
        }
    }
    
    init(index: Int, paper: PaperPresentView) {
        self.index = index
        self.paper = paper
        self.paper.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewDidLayoutSubviews() {
        paper.transform = .init(scaleX: scaleForFit, y: scaleForFit)
        super.viewDidLayoutSubviews()
    }
    
    private func initView() {
        view.addSubview(paper)
        view.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
        NSLayoutConstraint.activate([
            paper.widthAnchor.constraint(equalToConstant: paper.paperStyle.size.width),
            paper.heightAnchor.constraint(equalToConstant: paper.paperStyle.size.height),
            paper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paper.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
