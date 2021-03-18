//
//  FourPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/16.
//

import RxSwift

private enum Design {
    static let lineWidth: CGFloat = 1
    static let lineColor = UIColor(decimalRed: 233, green: 233, blue: 233, alpha: 0.5)
}

class FourPaper: UITableViewCell, PaperDescribing {
    var viewModel: PaperViewModel
    var paperStyle: PaperStyle
    
    private let fourImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .topLeft
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        super.init(style: .default, reuseIdentifier: FourPaper.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        fourImageView.image = getGridImage()
        contentView.addSubViewPinEdge(fourImageView)
    }
}

private extension FourPaper {
    func getGridImage() -> UIImage? {
        let paperSize = CGSize(width: paperStyle.paperWidth, height: paperStyle.paperHeight)
        UIGraphicsBeginImageContextWithOptions(paperSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setStrokeColor(Design.lineColor.cgColor)
        context.setLineWidth(Design.lineWidth)

        // vertical line
        let verticalStartPoint = CGPoint(x: paperSize.width / 2.0, y: 0)
        let verticalEndPoint = CGPoint(x: paperSize.width / 2.0, y: paperSize.height)

        context.move(to: verticalStartPoint)
        context.addLine(to: verticalEndPoint)

        // horizontal line
        let horizontalStartPoint = CGPoint(x: 0, y: paperSize.height / 2.0)
        let horizontalEndPoint = CGPoint(x: paperSize.width, y: paperSize.height / 2.0)

        context.move(to: horizontalStartPoint)
        context.addLine(to: horizontalEndPoint)

        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
