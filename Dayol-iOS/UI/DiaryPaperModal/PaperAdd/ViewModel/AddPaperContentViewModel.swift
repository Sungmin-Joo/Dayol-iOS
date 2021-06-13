//
//  AddPaperContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import Foundation

class AddPaperContentViewModel {
    private(set) var papers: [PaperStyle: [PaperModalModel.AddPaperCellModel]]
    private(set) var selectedPaper: PaperModalModel.AddPaperCellModel?
    
    init() {
        papers = [:]

        PaperStyle.allCases.forEach { orientation in
            papers[orientation] = PaperType.allCases.map {
                PaperModalModel.AddPaperCellModel(paperStyle: orientation, paperType: $0)
            }
        }
    }
    
    func selectCell(model cell: PaperModalModel.AddPaperCellModel) {
        selectedPaper = cell
    }
    
    func addPaper(diaryId: String) {
        guard let model = selectedPaper else { return }
        
        // TODO: 모델 init 간편화 필요
        // TODO: Model을 따로두고 Model이 Entity와 소통하도록 변경해야함
        let paperModel: Paper = Paper(id: DYTestData.shared.currentPaperId,
                                      diaryId: diaryId,
                                      title: model.title,
                                      pageCount: 1,
                                      orientation: .init(value: model.paperStyle),
                                      type: .init(value: model.paperType),
                                      width: model.paperStyle.size.width,
                                      height: model.paperStyle.size.height,
                                      thumbnail: nil,
                                      drawCanvas: Data(),
                                      contents: [],
                                      date: model.paperType.date)
        
        DYTestData.shared.addPaper(paperModel)
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
