//
//  GridPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

private enum Design {
    static let numberOfCellInRow: Int = 20
    static let numberOfCellInCol: Int = 40
    static let gridCellWidth: CGFloat = 20.0
    static let gridCellHeight: CGFloat = 20.0
    static let gridSize = CGSize(width: gridCellWidth * CGFloat(numberOfCellInRow),
                                 height: gridCellHeight * CGFloat(numberOfCellInCol))
    static let gridLineWidth: CGFloat = 1
    static let gridColor = UIColor(decimalRed: 233, green: 233, blue: 233, alpha: 0.5)
}

class GridPaperView: PaperView {

    private(set) var viewModel: PaperViewModel

    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(viewModel: PaperViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func getGridImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(Design.gridSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setStrokeColor(Design.gridColor.cgColor)
        context.setLineWidth(Design.gridLineWidth)
        context.setLineCap(.square)

        for row in 1..<Design.numberOfCellInCol {
            let positionY = row * Int(Design.gridCellHeight)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(Design.gridSize.width), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        for col in 1..<Design.numberOfCellInRow {
            let positionX = col * Int(Design.gridCellWidth)
            let startPoint = CGPoint(x: positionX, y: 0)
            let endPoint = CGPoint(x: positionX, y: Int(Design.gridSize.height))

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}

private extension GridPaperView {

    func initView() {
        gridImageView.image = getGridImage()
        contentView.addSubview(gridImageView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            gridImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gridImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gridImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gridImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
