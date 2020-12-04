//
//  ViewController.swift
//  Dayol
//
//  Created by 박종상 on 2020/12/04.
//

import UIKit

class ViewController: UIViewController {

	let helloDayolLabel: UILabel = {
		let label = UILabel()
		label.text = "Hello, Dayol"
		label.translatesAutoresizingMaskIntoConstraints = false
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
	}
}

