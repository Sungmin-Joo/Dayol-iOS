//
//  GridPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import RxSwift

private enum Design {
    static let gridLineWidth: CGFloat = 1
    static let gridColor = UIColor(decimalRed: 233, green: 233, blue: 233, alpha: 0.5)
}

private extension PaperType {
    static let gridCellWidth: CGFloat = 20.0
    static let gridCellHeight: CGFloat = 20.0

    var numberOfCellInRow: Int {
        return Int(paperWidth / Self.gridCellWidth) + 1
    }

    var numberOfCellInCol: Int {
        return Int(paperHeight / Self.gridCellHeight) + 1
    }

    var gridSize: CGSize {
        return CGSize(width: Self.gridCellWidth * CGFloat(numberOfCellInRow),
                      height: Self.gridCellHeight * CGFloat(numberOfCellInCol))
    }
}

class GridPaper: BasePaper {

    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(viewModel: PaperViewModel, paperType: PaperType) {
        super.init(viewModel: viewModel, paperType: paperType)

        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func getGridImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(paperType.gridSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setStrokeColor(Design.gridColor.cgColor)
        context.setLineWidth(Design.gridLineWidth)
        context.setLineCap(.square)

        for row in 0..<paperType.numberOfCellInCol + 1 {
            let positionY = row * Int(PaperType.gridCellHeight)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(paperType.gridSize.width), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        for col in 0..<paperType.numberOfCellInRow + 1{
            let positionX = col * Int(PaperType.gridCellWidth)
            let startPoint = CGPoint(x: positionX, y: 0)
            let endPoint = CGPoint(x: positionX, y: Int(paperType.gridSize.height))

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

private extension GridPaper {

    func initView() {
        drawArea.layer.masksToBounds = true
        drawArea.backgroundColor = CommonPaperDesign.defaultBGColor
        drawArea.translatesAutoresizingMaskIntoConstraints = false
        addSubview(drawArea)

        gridImageView.image = getGridImage()
        gridImageView.contentMode = .topLeft

        drawArea.addSubview(gridImageView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            gridImageView.centerXAnchor.constraint(equalTo: drawArea.centerXAnchor),
            gridImageView.centerYAnchor.constraint(equalTo: drawArea.centerYAnchor),
            gridImageView.widthAnchor.constraint(equalToConstant: paperType.paperWidth),
            gridImageView.heightAnchor.constraint(equalToConstant: paperType.paperHeight),

            drawArea.topAnchor.constraint(equalTo: topAnchor),
            drawArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            drawArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            drawArea.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
