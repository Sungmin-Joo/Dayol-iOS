//
//  PaperAddProgressView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/15.
//

import UIKit

private enum Design {
    enum Color{
        static let progressColor: UIColor = .dayolBrown
    }

    enum Size {
        static let progressCircleSize: CGSize = .init(width: 48, height: 48)
    }

    enum AnimationKey {
        static let rotateKeyPath = "transform.rotation"
        static let strokeKeyPath = "strokeEnd"
        static let progressKey = "kCircularProgressAnimationKey"
        static let spinKey = "kCircularSpinAnimationKey"
    }
}


final class CircularProgressView: UIView {
    // MARK: - UI Components
    let usesClockwise: Bool

    private let progressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center

        return imageView
    }()

    private let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = .none
        layer.lineWidth = 3
        layer.strokeColor = Design.Color.progressColor.cgColor
        layer.strokeEnd = 0
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 3

        return layer
    }()

    private var progressAnimation = CABasicAnimation()
    private var progress: CGFloat = 0.0
    var progressImage: UIImage? {
        didSet {
            progressImageView.image = progressImage
        }
    }

    init(usesClockwise: Bool) {
        self.usesClockwise = usesClockwise
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLayer()
        startAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateProgressLayer()
    }

    private func setupViews() {
        contentMode = .redraw
        backgroundColor = .clear

        addSubview(progressImageView)


        progressImageView.center = center
        progressImageView.contentMode = .center
    }

    private func setupLayer() {
        updateProgressLayer()
        layer.addSublayer(progressLayer)
    }

    private func updateProgressLayer() {
        progressImageView.frame = bounds
        progressLayer.frame = bounds

        progressLayer.path = makeBezierPath(usesClockWise: usesClockwise).cgPath
    }

    private func makeBezierPath(usesClockWise: Bool) -> UIBezierPath {
        let path: UIBezierPath = UIBezieㄴrPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midX),
                                              radius: bounds.size.width / 2,
                                              startAngle: 1.5 * .pi,
                                              endAngle: -0.5 * .pi,
                                              clockwise: usesClockWise)
        return path
    }

    private func startAnimation() {
        progressAnimation.keyPath = Design.AnimationKey.strokeKeyPath
        progressAnimation.fromValue = self.progress == 0 ? 0 : nil
        progressAnimation.toValue = 1
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        progressAnimation.duration = 3.0

        progressLayer.strokeEnd = 1
        progressLayer.add(progressAnimation, forKey: Design.AnimationKey.progressKey)
    }
}

extension CircularProgressView {
    func setProgress(_ progress: CGFloat, animated: Bool) {
//        if progress > 0 {
//            if animated {
//                progressAnimation.keyPath = Design.AnimationKey.strokeKeyPath
//                progressAnimation.fromValue = self.progress == 0 ? 0 : nil
//                progressAnimation.toValue = progress as NSNumber
//                progressAnimation.duration = 0.5
//
//                progressLayer.strokeEnd = progress
//                progressLayer.add(progressAnimation, forKey: Design.AnimationKey.progressKey)
//            } else {
//                CATransaction.begin()
//                CATransaction.setDisableActions(true)
//                progressLayer.strokeEnd = progress
//                CATransaction.commit()
//            }
//        } else {
//            progressLayer.strokeEnd = 0
//            progressLayer.removeAnimation(forKey: Design.AnimationKey.progressKey)
//        }

        self.progress = progress
    }

    func startLoading() {
        let progress: CGFloat = 0.93
        progressLayer.strokeEnd = progress
        progressLayer.removeAnimation(forKey: Design.AnimationKey.progressKey)

        let rotationAngle: CGFloat = 2 * .pi
        let rotationAtStart = progressLayer.value(forKey: Design.AnimationKey.rotateKeyPath)
        let rotationTransform = CATransform3DRotate(progressLayer.transform, rotationAngle, 0, 0, 1)
        progressLayer.transform = rotationTransform

        progressAnimation.keyPath = Design.AnimationKey.rotateKeyPath
        progressAnimation.duration = 2
        progressAnimation.fromValue = rotationAtStart
        progressAnimation.toValue = (rotationAtStart as? CGFloat ?? 0) + rotationAngle as NSNumber
        progressAnimation.repeatCount = .greatestFiniteMagnitude
        progressLayer.add(progressAnimation, forKey: Design.AnimationKey.spinKey)
    }
}
