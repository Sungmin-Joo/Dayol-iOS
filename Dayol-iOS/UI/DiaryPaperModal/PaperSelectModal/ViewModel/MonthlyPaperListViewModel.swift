//
//  PaperSelectModalViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import RxSwift
import Foundation

final class MonthlyPaperListViewModel {
    private let disposeBag = DisposeBag()
    var paperModels: [Paper]?

    init(diaryId: String, paperType: PaperType) {
        self.paperModels = DYTestData.shared.paperList.filter({ paper -> Bool in
            return (paper.diaryId == diaryId && paper.type == paperType)
        })
    }
}
