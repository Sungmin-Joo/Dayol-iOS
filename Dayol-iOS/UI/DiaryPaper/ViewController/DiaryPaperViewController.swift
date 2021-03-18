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
    
    init(index: Int, paper: PaperPresentView) {
        self.index = index
        self.paper = paper
        self.paper.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func initView() {
        view.addSubview(paper)
        
        NSLayoutConstraint.activate([
            paper.topAnchor.constraint(equalTo: view.topAnchor),
            paper.leftAnchor.constraint(equalTo: view.leftAnchor),
            paper.rightAnchor.constraint(equalTo: view.rightAnchor),
            paper.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
