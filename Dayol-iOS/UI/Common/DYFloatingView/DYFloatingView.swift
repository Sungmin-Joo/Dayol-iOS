//
//  DYFloatingView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/04/20.
//

import RxSwift
import RxCocoa

private enum Design {
    static let buttonTitleFont = UIFont.appleBold(size: 15)
    static let buttonTitleLetterSpacing: CGFloat = -0.28
    static let buttonTitleColor: UIColor = .white
    static let buttonAddImage = UIImage(named: "addPaper")
    static let buttonDeleteImage = UIImage(named: "deletePaper")
    static let buttonHeight: CGFloat = 40
    static let buttonSpacing: CGFloat = 20
    
    static let descFont = UIFont.appleRegular(size: 12)
    static let descLetterSpacing: CGFloat = -22
    static let descColor: UIColor = UIColor(decimalRed: 153, green: 153, blue: 153)

    static let separatorColor = UIColor(decimalRed: 95, green: 95, blue: 95)
    static let separatorSize = CGSize(width: 1, height: 20)
}

private enum Text: String {
    case addPaper = "DYFloatingView.addPaper"
    case deletePaper = "DYFloaingView.deletePaper"
    case desc = "DYFloatingView.desc"
    
    var localized: String {
        return self.rawValue.localized
    }
}

final class DYFloatingView: UIView {
    
}
