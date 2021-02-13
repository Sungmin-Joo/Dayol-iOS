//
//  AddPaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/13.
//

import Foundation

enum PaperModalModel {
    
    enum PaperOrientation: String, CaseIterable {
        case portrait
        case landscape
    }
    
    enum PaperStyle: String, CaseIterable {
        case monthly
        case weekly
        case daily
        case cornell
        case muji
        case grid
        case four
        case tracker
    }
    
    struct AddPaperCellModel {
        let orientation: PaperOrientation
        let style: PaperStyle
        
        var title: String {
            "Diary.Page.Add.\(style.rawValue)".localized
        }
        var thumbnailName: String {
            "paper_add_\(style.rawValue)_\(orientation.rawValue)"
        }
    }

    struct PaperListCellModel {
        let id: Int
        let isStarred: Bool
        let orientation: PaperOrientation
        let style: PaperStyle

        var title: String {
            "Diary.Page.Add.\(style.rawValue)".localized
        }
        // TODO: - 실제 썸네일 캡쳐 후 사용 시 모델 변경 필요
        var thumbnailName: String {
            "paper_add_\(style.rawValue)_\(orientation.rawValue)"
        }
    }
    
}
