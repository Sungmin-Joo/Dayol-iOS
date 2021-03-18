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

private extension PaperStyle {

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

class CornellPaper: UITableViewCell, PaperDescribing {
    var viewModel: PaperViewModel
    var paperStyle: PaperStyle
    
    private let cornellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private(set) var isFirstPage: Bool = true

    init(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        super.init(style: .default, reuseIdentifier: Self.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        cornellImageView.image = getCornellImage(isFirstPage: isFirstPage)
        cornellImageView.contentMode = .topLeft
        contentView.addSubViewPinEdge(cornellImageView)
    }
}

private extension CornellPaper {

    func getCornellImage(isFirstPage: Bool) -> UIImage? {
        let paperSize = CGSize(width: paperStyle.paperWidth, height: paperStyle.paperHeight)
        UIGraphicsBeginImageContextWithOptions(paperSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setLineWidth(Design.lineWidth)
        context.setLineCap(.square)

        // MARK: Draw Each base Line

        context.setStrokeColor(Design.lineColor.cgColor)

        let positionMargin = isFirstPage ? paperStyle.titleAreaHeight : 0

        for row in 0..<paperStyle.numberOfLineInPage(isFirstPage: isFirstPage) + 1 {
            let positionY = row * Int(PaperStyle.lineHeight) + Int(positionMargin)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(paperStyle.paperWidth), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        // MARK: Draw Red Line

        context.setStrokeColor(Design.redLineColor.cgColor)

        let positionX = paperStyle.redLineOriginX
        let startPoint = CGPoint(x: positionX, y: positionMargin)
        let endPoint = CGPoint(x: positionX, y: paperStyle.paperHeight)

        context.move(to: startPoint)
        context.addLine(to: endPoint)

        context.strokePath()

        // MARK: Draw Header If Needed

        if isFirstPage {
            context.setStrokeColor(Design.headerSeparatorColor.cgColor)

            let positionY = paperStyle.titleAreaHeight
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: paperStyle.paperWidth, y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)

            context.strokePath()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
