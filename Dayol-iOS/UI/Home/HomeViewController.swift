//
//  HomeViewController.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/09.
//

import UIKit

class HomeViewController: UIViewController {

    let helloDayolLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, Dayol"
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(helloDayolLabel)
        helloDayolLabel.center = view.center
        helloDayolLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
