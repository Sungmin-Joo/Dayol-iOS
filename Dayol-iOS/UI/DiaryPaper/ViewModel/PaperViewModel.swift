//
//  PaperViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit
import RxSwift

// 속지 기본 ViewModel
class PaperViewModel {
    let drawModel: DrawModel

    init(drawModel: DrawModel) {
        self.drawModel = drawModel
    }

}

class DailyPaperViewModel: PaperViewModel {

    enum Day: String {
        case mon = "Mon"
        case tue = "Tue"
        case wed = "Wed"
        case thu = "Thu"
        case fri = "Fri"
        case sat = "Sat"
        case sun = "Sun"
    }

    var date: BehaviorSubject<String>
    var day: BehaviorSubject<Day>

    init(date: Date, drawModel: DrawModel) {
        // TODO: - date와 day를 계산해서 넣어주는 로직
        self.date = BehaviorSubject<String>(value: "11.11")
        self.day = BehaviorSubject<Day>(value: .mon)
        super.init(drawModel: drawModel)
    }

}
