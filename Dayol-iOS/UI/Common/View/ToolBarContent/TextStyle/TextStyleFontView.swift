//
//  TextStyleFontView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//


import UIKit

private enum Design {
    static let topLine = UIColor(white: 220, alpha: 1)
    static let topLineHeight: CGFloat = 1

    static let tableViewSeparatorColor = UIColor(white: 247, alpha: 1)
}

class TextStyleFontView: UIView {

    let viewModel = TextStyleFontViewModel()

    // MARK: - UI Property

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Design.tableViewSeparatorColor
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.topLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        initView()
        setupCoantraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Initialize

private extension TextStyleFontView {
    func initView() {
        addSubview(topLine)
        addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextStyleFontCell.self,
                           forCellReuseIdentifier: TextStyleFontCell.className)
    }

    func setupCoantraints() {
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: topAnchor),
            topLine.leftAnchor.constraint(equalTo: leftAnchor),
            topLine.rightAnchor.constraint(equalTo: rightAnchor),
            topLine.heightAnchor.constraint(equalToConstant: Design.topLineHeight),

            tableView.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension TextStyleFontView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fonts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: TextStyleFontCell.className, for: indexPath)

        guard
            let fontCell = dequeCell as? TextStyleFontCell,
            let thumbnailName = viewModel.fonts[safe: indexPath.row]?.thumbnailName,
            let thumbnail = UIImage(named: thumbnailName)
        else { return dequeCell }

        fontCell.setFontImage(image: thumbnail)

        return fontCell
    }

}

// MARK: - UITableViewDelegate

extension TextStyleFontView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TextStyleFontCell.cellHeight
    }

}
