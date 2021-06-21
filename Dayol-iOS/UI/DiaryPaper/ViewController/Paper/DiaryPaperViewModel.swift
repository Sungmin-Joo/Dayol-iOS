//
//  DiaryPaperViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit
import RxSwift

class DiaryPaperViewModel {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    var paper: Paper
    let numberOfPapers: Int

    init(paper: Paper, numberOfPapers: Int) {
        self.paper = paper
        self.numberOfPapers = numberOfPapers

        bind()
    }

    private func bind() {
        DYTestData.shared.needsPaperUpdate
            .filter { $0.id == self.paper.id }
            .subscribe(onNext: { [weak self] paper in
                self?.paper = paper
            })
            .disposed(by: disposeBag)
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

    var isFavorite: Bool {
        return paper.isFavorite
    }
}
