//
//  PasswordViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/12.
//

import UIKit

private enum Desing {
	static let passwordImage: UIImage? = UIImage(named: "password_dayol")
	static let inputFont: UIFont? = UIFont(name: "AppleSDGothicNeo-Bold", size: 19.0)
	static let buttonFont: UIFont? = UIFont(name: "DXRMbxStd-B", size: 30.0)

	static let passwordHoriaontalSpacing: CGFloat = 14.0
	static let buttonHorizontalSpacing: CGFloat = 36.0
	static let buttonVerticalSpacing: CGFloat = 25.0
}

private enum Strings {
	static let inputNewPassword: String = "새 암호를 입력해주세요"
	static let inputNewPasswordMore: String = "한 번 더 입력해주세요"
	static let inputPassword: String = "함호를 입력해주세요"
}

class PasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
