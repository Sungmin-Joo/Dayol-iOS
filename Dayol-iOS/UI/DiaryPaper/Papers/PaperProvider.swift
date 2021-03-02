//
//  PaperProvider.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/23.
//

import UIKit

class PaperProvider {

    static func createPaper(paperType: PaperType, paperStyle: PaperStyle, drawModel: DrawModel) -> BasePaper {
        switch paperType {
        case .monthly:
            // monthly 연동
            let viewModel = PaperViewModel(drawModel: drawModel)
            return BasePaper(viewModel: viewModel, paperStyle: paperStyle)
        case .weekly:
            // weekly 연동
            let viewModel = PaperViewModel(drawModel: drawModel)
            return BasePaper(viewModel: viewModel, paperStyle: paperStyle)
        case .daily(let date):
            let viewModel = DailyPaperViewModel(date: date, drawModel: drawModel)
            return DailyPaper(viewModel: viewModel, paperStyle: paperStyle)
        case .cornell:
            let viewModel = PaperViewModel(drawModel: drawModel)
            return CornellPaper(viewModel: viewModel, paperStyle: paperStyle)
        case .muji:
            let viewModel = PaperViewModel(drawModel: drawModel)
            return MujiPaper(viewModel: viewModel, paperStyle: paperStyle)
        case .grid:
            let viewModel = PaperViewModel(drawModel: drawModel)
            return GridPaper(viewModel: viewModel, paperStyle: paperStyle)
        case .four:
            let viewModel = PaperViewModel(drawModel: drawModel)
            return FourPaper(viewModel: viewModel, paperStyle: paperStyle)
        case .tracker:
            // TODO: - tracker 구현
            let viewModel = PaperViewModel(drawModel: drawModel)
            return BasePaper(viewModel: viewModel, paperStyle: paperStyle)
        }
    }

}
