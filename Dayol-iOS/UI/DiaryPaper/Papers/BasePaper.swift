//
//  BasePaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import RxSwift

class BasePaper: UITableViewCell {
    var identifier: String { BasePaper.className }
    
    var viewModel: PaperViewModel?
    var paperStyle: PaperStyle?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        
        guard let paperStyle = self.paperStyle else { return }
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: paperStyle.size.width),
            contentView.heightAnchor.constraint(equalToConstant: paperStyle.size.height)
        ])
    }
}
