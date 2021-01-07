//
//  NSObject+Extension.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/07.
//

import Foundation

extension NSObject {

    static var className: String {
        String(describing: self)
    }

    var instanceType: String {
        String(describing: type(of: self))
    }

}
