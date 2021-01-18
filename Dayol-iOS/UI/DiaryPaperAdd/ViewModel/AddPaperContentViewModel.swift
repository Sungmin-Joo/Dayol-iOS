//
//  AddPaperContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import Foundation

class AddPaperContentViewModel {
    private(set) var papers: [AddPaperModel.PaperOrientation: [AddPaperModel.CellModel]]

    init() {
        papers = [:]

        AddPaperModel.PaperOrientation.allCases.forEach { orientation in
            papers[orientation] = AddPaperModel.PaperStyle.allCases.map {
                AddPaperModel.CellModel(orientation: orientation, style: $0)
            }
        }
    }
}

extension AddPaperContentViewModel {

    func cellModel(
        _ indexPath: IndexPath,
        orietation: AddPaperModel.PaperOrientation
    ) -> AddPaperModel.CellModel? {

        guard let cellModel = papers[orietation]?[safe: indexPath.row] else {
            return nil
        }
        return cellModel

    }

}
