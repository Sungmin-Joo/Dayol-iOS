//
//  DYNavigationItemCreator.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/30.
//

import UIKit

enum DYNavigationItemType {
    case backWhite
    case back
    case cancel
    case done
    case more
    case downArrowChevron
}

enum DYNavigationToolbarType {
    case function
    case draw
}

private enum Design {
    static let buttonSize: CGSize = CGSize(width: 40, height: 40)
    
    static let backButtonWhiteImage: UIImage? = UIImage(named: "backButtonWhite")
    static let backButtonImage: UIImage? = UIImage(named: "backButton")
    static let cancelButtonImage: UIImage? = UIImage(named: "cancelButton")
    static let doneButtonImage: UIImage? = UIImage(named: "doneButton")
    static let moreButtonImage: UIImage? = UIImage(named: "moreButton")
    static let downwardArrowButtonImage: UIImage? = UIImage(named: "downwardArrowButton")
}

class DYNavigationItemCreator: NSObject {
    static func titleView(_ text: String, color: UIColor = .gray900) -> DYNavigationTitle {
        return DYNavigationTitle(text: text, color: color)
    }
    
    static func editableTitleView(_ text: String, color: UIColor = .gray900) -> DYNavigationEditableTitle {
        return DYNavigationEditableTitle(text: text, color: color)
    }
    
    static func barButton(type: DYNavigationItemType) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.height, height: Design.buttonSize.width))
        var buttonImage: UIImage?
        switch type {
        case .backWhite: buttonImage = Design.backButtonWhiteImage
        case .back: buttonImage = Design.backButtonImage
        case .cancel: buttonImage = Design.cancelButtonImage
        case .done: buttonImage = Design.doneButtonImage
        case .more: buttonImage = Design.moreButtonImage
        case .downArrowChevron: buttonImage = Design.downwardArrowButtonImage
        }
    
        button.setImage(buttonImage, for: .normal)
        return button
    }
    
    static func drawingFunctionToolbar() -> DYNavigationDrawingToolbar {
        return DYNavigationDrawingToolbar()
    }
    
    static func functionToolbar() -> DYNavigationFunctionToolBar {
        return DYNavigationFunctionToolBar()
    }
}
