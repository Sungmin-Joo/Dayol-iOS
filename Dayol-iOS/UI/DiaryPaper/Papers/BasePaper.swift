//
//  BasePaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import RxSwift

protocol PaperDescribing {
    var viewModel: PaperViewModel { get set }
    var paperStyle: PaperStyle { get set }
    
    func configure()
}

extension PaperDescribing {
    func setup() {
        configure()
    }
}
