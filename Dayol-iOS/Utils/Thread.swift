//
//  Thread.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/15.
//

import Foundation

/// Execute immediately if called on main thread. Or execute async on Main Thread.
public func executeOnMainThread(_ execute: @escaping () -> Void) {
    if Thread.isMainThread {
        execute()
    }
    else {
        DispatchQueue.main.async(execute: execute)
    }
}

public func executeOnMainThread(delay: Float64, _ execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: execute)
}
