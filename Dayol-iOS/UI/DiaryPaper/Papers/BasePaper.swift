//
//  BasePaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import RxSwift

class BasePaper: UIView {
    let disposeBag = DisposeBag()
    var paperStyle: PaperStyle
    var viewModel: PaperViewModel
    var drawArea: UIView = {
        // TODO: - 아마 canvas 뷰로 대체
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = CommonPaperDesign.defaultBGColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        super.init(frame: .zero)

        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func initView() {
        addSubview(drawArea)
        setPaperBorder()
    }

    func setPaperBorder(color: CGColor = CommonPaperDesign.borderColor.cgColor) {
        layer.borderWidth = 1
        layer.borderColor = color
    }

    func setConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            drawArea.topAnchor.constraint(equalTo: topAnchor),
            drawArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            drawArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            drawArea.bottomAnchor.constraint(equalTo: bottomAnchor),

            widthAnchor.constraint(equalToConstant: paperStyle.paperWidth),
            heightAnchor.constraint(equalToConstant: paperStyle.paperHeight)
        ])
    }
}
