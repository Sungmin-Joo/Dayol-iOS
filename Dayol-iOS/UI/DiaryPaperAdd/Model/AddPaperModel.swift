//
//  AddPaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/13.
//

import Foundation

enum AddPaperModel {
    
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
    
    struct CellModel {
        let orientation: PaperOrientation
        let style: PaperStyle
        
        var title: String {
            "Diary.Page.Add.\(style.rawValue)".localized
        }
        var thumbnailName: String {
            "paper_add_\(style.rawValue)_\(orientation.rawValue)"
        }
    }
    
}
