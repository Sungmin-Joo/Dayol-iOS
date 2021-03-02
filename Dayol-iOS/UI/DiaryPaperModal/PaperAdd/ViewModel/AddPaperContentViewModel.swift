//
//  AddPaperContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import Foundation

class AddPaperContentViewModel {
    private(set) var papers: [PaperStyle: [PaperModalModel.AddPaperCellModel]]

    init() {
        papers = [:]

        PaperStyle.allCases.forEach { orientation in
            papers[orientation] = PaperType.allCases.map {
                PaperModalModel.AddPaperCellModel(paperStyle: orientation, paperType: $0)
            }
        }
    }
}

extension AddPaperContentViewModel {

    func cellModel(_ indexPath: IndexPath, paperStyle: PaperStyle) -> PaperModalModel.AddPaperCellModel? {

        guard let cellModel = papers[paperStyle]?[safe: indexPath.row] else {
            return nil
        }
        return cellModel

    }

}
