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
    
    let sizeDefinitionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        contentView.addSubview(sizeDefinitionView)
        guard let paperStyle = self.paperStyle else { return }
        
        NSLayoutConstraint.activate([
            sizeDefinitionView.widthAnchor.constraint(equalToConstant: paperStyle.size.width),
            sizeDefinitionView.heightAnchor.constraint(equalToConstant: paperStyle.size.height),
            sizeDefinitionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sizeDefinitionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalTo: sizeDefinitionView.heightAnchor)
        ])
    }
}
