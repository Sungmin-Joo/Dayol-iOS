//
//  AddPaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/13.
//

import UIKit

enum PaperModalModel {
    struct AddPaperCellModel {
        let orientation: Paper.PaperOrientation
        let paperType: PaperType
        
        var title: String {
            paperType.typeName
        }
        var thumbnailName: String {
            paperType.tumbNailImageName + "_\(orientation.rawValue.lowercased())"
        }
    }

    struct PaperListCellModel {
        let id: String
        let isStarred: Bool
        let orientation: Paper.PaperOrientation
        let paperType: PaperType
        let thumbnailData: Data?

        init(id: String, isStarred: Bool, orientation: Paper.PaperOrientation, paperType: PaperType, thumbnailData: Data?) {
            self.id = id
            self.isStarred = isStarred
            self.orientation = orientation
            self.paperType = paperType
            self.thumbnailData = thumbnailData
        }

        var title: String {
            paperType.title
        }

        var thumbnailName: String {
            return paperType.tumbNailImageName + "_\(orientation.rawValue.lowercased())"
        }
    }
}

private extension PaperType {
    var tumbNailImageName: String {
        switch self {
        case .monthly: return "paper_add_monthly"
        case .weekly: return "paper_add_weekly"
        case .daily(_): return "paper_add_daily"
        case .cornell: return "paper_add_cornell"
        case .muji: return "paper_add_muji"
        case .grid: return "paper_add_grid"
        case .quartet: return "paper_add_four"
        case .tracker: return "paper_add_tracker"
        }
    }
}
