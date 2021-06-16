//
//  PaperAddProgressView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/15.
//

import UIKit
import RxSwift

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
    let progressDidChanged = PublishSubject<CGFloat>()

    private let progressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center

        return imageView
    }()

    private let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = .none
        return layer
    }()

    private var progressAnimation = CABasicAnimation()
    private var progress: CGFloat = 0.0
    var progressImage: UIImage? {
        didSet {
            self.progressImageView.image = self.progressImage
        }
    }

    init(usesClockwise: Bool) {
        self.usesClockwise = usesClockwise
        super.init(frame: .zero)
        setupViews()
        setupLayer()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        progressImageView.center = center
        updateProgressLayer()
    }

    private func setupViews() {
        contentMode = .redraw
        backgroundColor = .clear

        addSubview(progressImageView)

        progressImageView.center = center
        progressImageView.contentMode = .center

        layer.cornerRadius = Design.Size.progressCircleSize.width / 2
        layer.masksToBounds = true
    }

    private func setupLayer() {
        progressLayer.lineWidth = 2
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = Design.Color.progressColor.cgColor
        layer.addSublayer(progressLayer)
    }

    private func updateProgressLayer() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) * 0.5 - (progressLayer.lineWidth * 0.5)
        let startAngle = CGFloat(-CGFloat.pi * 0.5)
        let endAngle = startAngle + CGFloat(CGFloat.pi * 2)

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: usesClockwise
        )

        progressLayer.path = path.cgPath
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
    func setImageAlpha(_ alpha: CGFloat) {
        progressImageView.alpha = alpha
    }

    func setProgress(_ progress: CGFloat, animated: Bool) {
        if progress > 0 {
            if animated {
                progressAnimation.keyPath = Design.AnimationKey.strokeKeyPath
                progressAnimation.fromValue = self.progress == 0 ? 0 : nil
                progressAnimation.toValue = progress as NSNumber
                progressAnimation.duration = 0.5

                progressLayer.strokeEnd = progress
                progressLayer.add(progressAnimation, forKey: Design.AnimationKey.progressKey)
            } else {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                progressLayer.strokeEnd = progress
                CATransaction.commit()
            }
        } else {
            progressLayer.strokeEnd = 0
            progressLayer.removeAnimation(forKey: Design.AnimationKey.progressKey)
        }

        self.progress = progress
        progressDidChanged.onNext(progress)
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
