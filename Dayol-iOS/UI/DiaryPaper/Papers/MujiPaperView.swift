//
//  MujiPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

class MujiPaperView: BasePaperView {

    private let contentArea = UIView()
    private(set) var viewModel: PaperViewModel

    init(viewModel: PaperViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

private extension MujiPaperView {

    func initView() {
        contentArea.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentArea)
        contentArea.backgroundColor = .red
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentArea.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
