//
//  MujiPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import RxSwift

class MujiPaper: BasePaper {

    override init(viewModel: PaperViewModel, paperType: PaperType) {
        super.init(viewModel: viewModel, paperType: paperType)

        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension MujiPaper {

    func initView() {
        drawArea.backgroundColor = CommonPaperDesign.defaultBGColor
        drawArea.translatesAutoresizingMaskIntoConstraints = false
        addSubview(drawArea)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            drawArea.topAnchor.constraint(equalTo: topAnchor),
            drawArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            drawArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            drawArea.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
