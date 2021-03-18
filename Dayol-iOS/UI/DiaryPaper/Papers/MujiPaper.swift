//
//  MujiPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import RxSwift

class MujiPaper: UITableViewCell ,PaperDescribing {
    
    var viewModel: PaperViewModel
    var paperStyle: PaperStyle
    
    init(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        super.init(style: .default, reuseIdentifier: MujiPaper.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
}

