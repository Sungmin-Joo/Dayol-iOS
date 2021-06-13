//
//  DiaryPaperViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit

class DiaryPaperViewModel {
    
    // MARK: - Properties
    
    let paper: Paper
    let numberOfPapers: Int
    
    init(paper: Paper, numberOfPapers: Int) {
        self.paper = paper
        self.numberOfPapers = numberOfPapers
    }
}

extension DiaryPaperViewModel {
    var paperId: String {
        return paper.id
    }

    var diaryId: String {
        return paper.diaryId
    }

    var orientation: Paper.PaperOrientation {
        return Paper.PaperOrientation(rawValue: paper.orientation) ?? .portrait
    }

    var paperType: PaperType {
        return paper.type
    }

    var width: CGFloat {
        return CGFloat(paper.width)
    }

    var height: CGFloat {
        return CGFloat(paper.height)
    }
}
