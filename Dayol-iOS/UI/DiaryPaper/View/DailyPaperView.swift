//
//  DailyPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

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

class DailyPaperView: PaperView {

    private let titleArea = UIView()
    private let contentArea = UIView()
    private let dateLabel = UILabel()
    private let dayLabel = UILabel()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) var viewModel: DailyPaperViewModel

    init(viewModel: DailyPaperViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

private extension DailyPaperView {

    func initView() {
        dateLabel.attributedText = NSAttributedString.build(text: viewModel.date,
                                                            font: Design.dateFont,
                                                            align: .left,
                                                            letterSpacing: Design.dateSpacing,
                                                            foregroundColor: Design.titleColor)
        dateLabel.sizeToFit()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleArea.addSubview(dateLabel)

        dayLabel.attributedText = NSAttributedString.build(text: viewModel.day.rawValue,
                                                           font: Design.dayFont,
                                                           align: .left,
                                                           letterSpacing: Design.daySpacing,
                                                           foregroundColor: Design.titleColor)
        dayLabel.sizeToFit()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        titleArea.addSubview(dayLabel)

        titleArea.addSubview(separatorView)
        titleArea.translatesAutoresizingMaskIntoConstraints = false
        contentArea.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleArea)
        contentView.addSubview(contentArea)
    }

    func setupConstraints() {
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

            titleArea.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleArea.heightAnchor.constraint(equalToConstant: Design.titleAreaHeight),

            contentArea.topAnchor.constraint(equalTo: titleArea.bottomAnchor),
            contentArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
