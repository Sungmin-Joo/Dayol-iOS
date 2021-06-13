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
    var paperModels: [Paper] { DYTestData.shared.paperList }
}
