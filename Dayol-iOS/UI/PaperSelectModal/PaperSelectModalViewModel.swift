//
//  PaperSelectModalViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import Foundation

final class PaperSelectModalViewModel {
    let paperModels: [DiaryInnerModel.PaperModel]

    init(paperModels: [DiaryInnerModel.PaperModel]) {
        self.paperModels = paperModels
    }
}
