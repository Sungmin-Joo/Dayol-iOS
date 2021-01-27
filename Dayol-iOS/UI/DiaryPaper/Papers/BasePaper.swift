//
//  BasePaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import RxSwift

class BasePaper: UIView {
    let disposeBag = DisposeBag()
    var paperType: PaperType
    var viewModel: PaperViewModel
    var drawArea: UIView = {
        // TODO: - 아마 canvas 뷰로 대체
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = CommonPaperDesign.defaultBGColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: PaperViewModel, paperType: PaperType) {
        self.viewModel = viewModel
        self.paperType = paperType
        super.init(frame: .zero)

        initView()
        setConstraints()
        bindEvent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func bindEvent() {
        viewModel.drawModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { drawModel in
                // TODO: - 데이터 바인딩
            })
            .disposed(by: disposeBag)
    }

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

            widthAnchor.constraint(equalToConstant: paperType.paperWidth),
            heightAnchor.constraint(equalToConstant: paperType.paperHeight)
        ])
    }
}
