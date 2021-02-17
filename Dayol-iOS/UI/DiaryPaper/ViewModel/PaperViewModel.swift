//
//  PaperViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import RxSwift

// 속지 기본 ViewModel
class PaperViewModel {
    var drawModel = BehaviorSubject<DrawModel>(value: DrawModel())

    func fetchData(paperID: Int) {
        // ID값이나 key값을 통해 속지의 데이터를 불러오는 로직
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

    init(date: String, day: Day) {
        self.date = BehaviorSubject<String>(value: date)
        self.day = BehaviorSubject<Day>(value: day)
    }

}
