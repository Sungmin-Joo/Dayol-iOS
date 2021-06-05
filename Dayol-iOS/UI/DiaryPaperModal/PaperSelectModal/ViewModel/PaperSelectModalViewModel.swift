//
//  PaperSelectModalViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import RxSwift
import Foundation

final class PaperSelectModalViewModel {
    private let disposeBag = DisposeBag()
    var paperModels: [DiaryInnerModel.PaperModel] { DYTestData.shared.paperList }
}
