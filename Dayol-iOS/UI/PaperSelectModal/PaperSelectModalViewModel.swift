//
//  PaperSelectModalViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import RxSwift
import Foundation

final class PaperSelectModalViewModel {
    private let disposeBag = DisposeBag()
    var paperModels =  DYTestData.shared.paperList

    init() {
        bind()
    }

    private func bind() {
        DYTestData.shared.pageListSubject
            .subscribe(onNext: { [weak self] papers in
                self?.paperModels = papers
            })
            .disposed(by: disposeBag)
    }
}
