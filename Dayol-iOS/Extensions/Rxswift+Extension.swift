//
//  Rxswift+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/07/02.
//

import UIKit
import RxSwift

extension ObserverType {

}

extension PrimitiveSequence where Trait == SingleTrait {
    func attachHUD() -> PrimitiveSequence {
        return self.do { _ in
            executeOnMainThread { DYHUD.hide() }
        } onError: { _ in
            executeOnMainThread { DYHUD.hide() }
        } onSubscribe: {
            executeOnMainThread { DYHUD.show() }
        } onDispose: {
            executeOnMainThread { DYHUD.hide() }
        }
    }

    func attachHUD(_ view: UIView) -> PrimitiveSequence {
        return self.do { _ in
            executeOnMainThread { DYHUD.hide(view) }
        } onError: { _ in
            executeOnMainThread { DYHUD.hide(view) }
        } onSubscribe: {
            executeOnMainThread { DYHUD.show(view) }
        } onDispose: {
            executeOnMainThread { DYHUD.hide(view) }
        }
    }
}
