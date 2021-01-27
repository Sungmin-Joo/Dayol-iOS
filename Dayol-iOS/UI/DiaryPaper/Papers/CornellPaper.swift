//
//  CornellPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/27.
//

import RxSwift

private enum Design {
    static let redLineColor = UIColor(decimalRed: 226, green: 88, blue: 88)
    static let headerSeparatorColor = UIColor(decimalRed: 102, green: 102, blue: 102)
    static let lineColor = UIColor(decimalRed: 233, green: 233, blue: 233)

    static let lineWidth: CGFloat = 1
}

private extension PaperType {

    static let lineHeight: CGFloat = 30.0

    var titleAreaHeight: CGFloat {
        switch self {
        case .horizontal: return 50.0
        case .vertical: return 64.0
        }
    }

    var redLineOriginX: CGFloat {
        switch self {
        case .horizontal: return 200.0
        case .vertical: return 100.0
        }
    }

    func numberOfLineInPage(isFirstPage: Bool) -> Int {
        if isFirstPage {
            return Int(paperHeight - titleAreaHeight / Self.lineHeight) + 1
        } else {
            return Int(paperHeight / Self.lineHeight) + 1
        }
    }

}

class CornellPaper: BasePaper {

    private let cornellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private(set) var isFirstPage: Bool

    init(viewModel: PaperViewModel, paperType: PaperType, isFirstPage: Bool) {
        self.isFirstPage = isFirstPage
        super.init(viewModel: viewModel, paperType: paperType)

        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func getCornellImage(isFirstPage: Bool) -> UIImage? {
        let paperSize = CGSize(width: paperType.paperWidth, height: paperType.paperHeight)
        UIGraphicsBeginImageContextWithOptions(paperSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setLineWidth(Design.lineWidth)
        context.setLineCap(.square)

        // MARK: Draw Each base Line

        context.setStrokeColor(Design.lineColor.cgColor)

        let positionMargin = isFirstPage ? paperType.titleAreaHeight : 0

        for row in 0..<paperType.numberOfLineInPage(isFirstPage: isFirstPage) + 1 {
            let positionY = row * Int(PaperType.lineHeight) + Int(positionMargin)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(paperType.paperWidth), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        // MARK: Draw Red Line

        context.setStrokeColor(Design.redLineColor.cgColor)

        let positionX = paperType.redLineOriginX
        let startPoint = CGPoint(x: positionX, y: positionMargin)
        let endPoint = CGPoint(x: positionX, y: paperType.paperHeight)

        context.move(to: startPoint)
        context.addLine(to: endPoint)

        context.strokePath()

        // MARK: Draw Header If Needed

        if isFirstPage {
            context.setStrokeColor(Design.headerSeparatorColor.cgColor)

            let positionY = paperType.titleAreaHeight
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: paperType.paperWidth, y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)

            context.strokePath()
        }


        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

private extension CornellPaper {

    func initView() {
        addSubview(drawArea)

        cornellImageView.image = getCornellImage(isFirstPage: isFirstPage)
        cornellImageView.contentMode = .topLeft

        drawArea.addSubview(cornellImageView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            cornellImageView.centerXAnchor.constraint(equalTo: drawArea.centerXAnchor),
            cornellImageView.centerYAnchor.constraint(equalTo: drawArea.centerYAnchor),
            cornellImageView.widthAnchor.constraint(equalToConstant: paperType.paperWidth),
            cornellImageView.heightAnchor.constraint(equalToConstant: paperType.paperHeight),

            drawArea.topAnchor.constraint(equalTo: topAnchor),
            drawArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            drawArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            drawArea.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
