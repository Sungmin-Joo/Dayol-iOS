//
//  DailyPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import RxSwift

private enum Design {
    static let titleColor = UIColor.black
    static let titleAreaHeight: CGFloat = 60.0

    static let separatorColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorHeight: CGFloat = 1.0

    static let dateFont = UIFont.helveticaBold(size: 26.0)
    static let dateSpacing: CGFloat = -0.79
    static let dayFont = UIFont.systemFont(ofSize: 13.0, weight: .bold)
    static let daySpacing: CGFloat = -0.5

    static let dateLeftMargin: CGFloat = 18.0
    static let dayLeftMargin: CGFloat = 7.0
}

class DailyPaper: BasePaper {

    private let titleArea = UIView()
    private let dateLabel = UILabel()
    private let dayLabel = UILabel()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: DailyPaperViewModel, paperStyle: PaperStyle) {
        super.init(viewModel: viewModel, paperStyle: paperStyle)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func bindEvent() {
        super.bindEvent()

        guard let viewModel = viewModel as? DailyPaperViewModel else { return }

        viewModel.date
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] dateString in
                self?.setDateLabel(dateString)

            })
            .disposed(by: disposeBag)

        viewModel.day
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] day in
                self?.setDayLabel(day)

            })
            .disposed(by: disposeBag)
    }

    override func initView() {
        super.initView()
        dateLabel.sizeToFit()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleArea.addSubview(dateLabel)

        dayLabel.sizeToFit()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        titleArea.addSubview(dayLabel)
        titleArea.addSubview(separatorView)
        titleArea.translatesAutoresizingMaskIntoConstraints = false

        drawArea.addSubview(titleArea)
        drawArea.backgroundColor = CommonPaperDesign.defaultBGColor
        drawArea.translatesAutoresizingMaskIntoConstraints = false
        addSubview(drawArea)
    }

    override func setConstraints() {
        super.setConstraints()
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: titleArea.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleArea.leadingAnchor,
                                               constant: Design.dateLeftMargin),

            dayLabel.firstBaselineAnchor.constraint(equalTo: dateLabel.firstBaselineAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor,
                                               constant: Design.dayLeftMargin),

            separatorView.leadingAnchor.constraint(equalTo: titleArea.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: titleArea.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: titleArea.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Design.separatorHeight),

            titleArea.topAnchor.constraint(equalTo: drawArea.topAnchor),
            titleArea.leadingAnchor.constraint(equalTo: drawArea.leadingAnchor),
            titleArea.trailingAnchor.constraint(equalTo: drawArea.trailingAnchor),
            titleArea.heightAnchor.constraint(equalToConstant: Design.titleAreaHeight)
        ])
    }

}

private extension DailyPaper {

    func setDateLabel(_ dateString: String) {
        dateLabel.attributedText = NSAttributedString.build(text: dateString,
                                                            font: Design.dateFont,
                                                            align: .left,
                                                            letterSpacing: Design.dateSpacing,
                                                            foregroundColor: Design.titleColor)
    }

    func setDayLabel(_ day: DailyPaperViewModel.Day) {
        dayLabel.attributedText = NSAttributedString.build(text: day.rawValue,
                                                           font: Design.dayFont,
                                                           align: .left,
                                                           letterSpacing: Design.daySpacing,
                                                           foregroundColor: Design.titleColor)
    }
}
