//
//  DYNavigationItemCreator.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/30.
//

import UIKit

enum DYNavigationItemType {
    case back
    case cancel
    case done
    case more
}

private enum Design {
    static let buttonSize: CGSize = CGSize(width: 40, height: 40)
    
    static let backButtonImage: UIImage? = UIImage(named: "backButton")
    static let cancelButtonImage: UIImage? = UIImage(named: "cancelButton")
    static let doneButtonImage: UIImage? = UIImage(named: "doneButton")
    static let moreButtonImage: UIImage? = UIImage(named: "moreButton")
}

class DYNavigationItemCreator: NSObject {
    static func titleView(_ text: String) -> DYNavigationTitle {
        return DYNavigationTitle(text: text)
    }
    
    static func editableTitleView(_ text: String) -> DYNavigationEditableTitle {
        return DYNavigationEditableTitle(text: text)
    }
    
    static func button(type: DYNavigationItemType) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.height, height: Design.buttonSize.width))
        var buttonImage: UIImage?
        switch type {
        case .back: buttonImage = Design.backButtonImage
        case .cancel: buttonImage = Design.cancelButtonImage
        case .done: buttonImage = Design.doneButtonImage
        case .more: buttonImage = Design.moreButtonImage
        }
        
        button.setImage(buttonImage, for: .normal)

        return button
    }
}
