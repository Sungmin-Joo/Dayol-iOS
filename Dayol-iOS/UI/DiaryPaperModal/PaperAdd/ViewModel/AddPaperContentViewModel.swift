//
//  AddPaperContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import Foundation

class AddPaperContentViewModel {
    private(set) var papers: [PaperModalModel.PaperOrientation: [PaperModalModel.AddPaperCellModel]]

    init() {
        papers = [:]

        PaperModalModel.PaperOrientation.allCases.forEach { orientation in
            papers[orientation] = PaperModalModel.PaperStyle.allCases.map {
                PaperModalModel.AddPaperCellModel(orientation: orientation, style: $0)
            }
        }
    }
}

extension AddPaperContentViewModel {

    func cellModel(
        _ indexPath: IndexPath,
        orietation: PaperModalModel.PaperOrientation
    ) -> PaperModalModel.AddPaperCellModel? {

        guard let cellModel = papers[orietation]?[safe: indexPath.row] else {
            return nil
        }
        return cellModel

    }

}
