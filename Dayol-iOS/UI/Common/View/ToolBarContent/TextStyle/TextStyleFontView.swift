//
//  TextStyleFontView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//


import UIKit

private enum Design {
    static let topLineColor = UIColor(white: 220 / 255, alpha: 1)
    static let topLineHeight: CGFloat = 1

    static let tableViewSeparatorColor = UIColor(white: 247 / 255, alpha: 1)
}

class TextStyleFontView: UIView {

    let viewModel: TextStyleFontViewModel

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
        view.backgroundColor = Design.topLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    init(currentFontName: String?) {
        self.viewModel = TextStyleFontViewModel(currentFontName: currentFontName)
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
            topLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: Design.topLineHeight),

            tableView.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
            let font = viewModel.fonts[safe: indexPath.row]
        else { return dequeCell }

        if let thumbnailName = font.thumbnailName {
            fontCell.setFontImage(image: UIImage(named: thumbnailName))
        }

        if let currentFont = try? viewModel.currentFontSubject.value(), currentFont == font {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return fontCell
    }

}

// MARK: - UITableViewDelegate

extension TextStyleFontView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TextStyleFontCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedRow(at: indexPath.row)
    }

}
