//
//  DYStickerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/13.
//

import UIKit

// MARK: - Enums

public enum DYStickerViewHandler: Int {
    case close = 0
    case wStretch
    case hStretch
    case rotate
}

public enum DYStickerViewHandlerPosition: Int {
    case topLeft = 0
    case topRight
    case bottomLeft
    case bottomRight
    case top
    case left
    case right
    case bottom
}

// MARK: - Delegate

@objc
public protocol DYStickerViewDelegate {
    @objc func stickerView(_ stickerView: DYStickerView, didBeginMove point: CGPoint)
    @objc func stickerView(_ stickerView: DYStickerView, didChangeMove point: CGPoint)
    @objc func stickerView(_ stickerView: DYStickerView, didEndMove point: CGPoint)
    @objc func stickerView(_ stickerView: DYStickerView, didBeginRotate angle: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didChangeRotate angle: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didEndRotate angle: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didBeginWidth: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didChangeWidth: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didEndWidth: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didBeginHeight: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didChangeHeight: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didEndHeight: CGFloat)
    @objc func stickerView(_ stickerView: DYStickerView, didTapClose: Bool)
    @objc func stickerView(_ stickerView: DYStickerView, didTapSticker: Bool)
}

// For Optional Delegate
extension DYStickerViewDelegate {
    func stickerView(_ stickerView: DYStickerView, didBeginMove point: CGPoint) { }
    func stickerView(_ stickerView: DYStickerView, didChangeMove point: CGPoint) { }
    func stickerView(_ stickerView: DYStickerView, didEndMove point: CGPoint) { }
    func stickerView(_ stickerView: DYStickerView, didBeginRotate angle: Float) { }
    func stickerView(_ stickerView: DYStickerView, didChangeRotate angle: Float) { }
    func stickerView(_ stickerView: DYStickerView, didEndRotate angle: Float) { }
    func stickerView(_ stickerView: DYStickerView, didBeginWidth: CGFloat) { }
    func stickerView(_ stickerView: DYStickerView, didChangeWidth: CGFloat) { }
    func stickerView(_ stickerView: DYStickerView, didEndWidth: CGFloat) { }
    func stickerView(_ stickerView: DYStickerView, didBeginHeight: CGFloat) { }
    func stickerView(_ stickerView: DYStickerView, didChangeHeight: CGFloat) { }
    func stickerView(_ stickerView: DYStickerView, didEndHeight: CGFloat) { }
    func stickerView(_ stickerView: DYStickerView, didTapClose: Bool) { }
    func stickerView(_ stickerView: DYStickerView, didTapSticker: Bool) { }
}

public class DYStickerView: UIView {
    // MARK: - UI & Gesture
    
    private lazy var closeImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.closeGesture)
        
        return imageView
    }()
    
    private lazy var closeGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleCloseGesture(_:)))
    }()
    
    private lazy var rotateImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.rotateGesture)
        
        return imageView
    }()
    
    private lazy var rotateGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
    }()
    
    private lazy var wStretchImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.wStretchGesture)
        
        return imageView
    }()
    
    private lazy var wStretchGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleWStretchGesture(_:)))
    }()
    
    private lazy var hStretchImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.hStretchGesture)
        
        return imageView
    }()
    
    private lazy var hStretchGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleHStretchGesture(_:)))
    }()
    
    private lazy var tapGesture = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    }()
    
    private lazy var moveGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
    }()
    
    // MARK: - Initailize
    
    public var contentView: UIView!
    public weak var delegate: DYStickerViewDelegate?
    
    public var enableClose: Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableClose(self.enableClose)
            }
        }
    }
    
    public var enableRotate: Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableRotate(self.enableRotate)
            }
        }
    }
    
    public var enableWStretch: Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableWStretch(self.enableWStretch)
            }
        }
    }
    
    public var enableHStretch: Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableHStretch(self.enableHStretch)
            }
        }
    }
    
    public var showEditingHandlers: Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableRotate(self.enableRotate)
                self.setEnableClose(self.enableClose)
                self.setEnableWStretch(self.enableWStretch)
                self.setEnableHStretch(self.enableHStretch)
                self.contentView.layer.borderWidth = 1
            } else {
                self.setEnableRotate(false)
                self.setEnableClose(false)
                self.setEnableWStretch(false)
                self.setEnableHStretch(false)
                self.contentView.layer.borderWidth = 0
            }
        }
    }
    
    private var _minimumSize: NSInteger = 0
    private var _outlineBorderColor: UIColor = .clear
    
    private var defaultInset:NSInteger
    private var defaultMinimumSize:NSInteger
    
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    
    private var initialBounds = CGRect.zero
    private var initialDistance:CGFloat = 0
    private var deltaAngle:CGFloat = 0
   
    public init(contentView: UIView) {
        var frame = contentView.frame
        self.contentView = contentView
        self.defaultInset = 11
        self.defaultMinimumSize = 4 * self.defaultInset
        
        frame = CGRect(x: 0,
                       y: 0,
                       width: frame.size.width + CGFloat(defaultInset) * 2,
                       height: frame.size.height + CGFloat(defaultInset) * 2)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        setupGesture()
        initContentView()
        setupHandlers()
        
        self.minimumSize = self.defaultMinimumSize
        self.outlineBorderColor = .brown
    }
    
    private func initContentView() {
        self.contentView.center = centerPoint(self.bounds)
        self.contentView.isUserInteractionEnabled = false
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.layer.allowsEdgeAntialiasing = true
        self.addSubview(self.contentView)
    }
    
    private func setupGesture() {
        self.addGestureRecognizer(self.moveGesture)
        self.addGestureRecognizer(self.tapGesture)
    }
    
    private func setupHandlers() {
        self.setPosition(.topLeft, for: .close)
        self.addSubview(self.closeImageView)
        self.setPosition(.right, for: .wStretch)
        self.addSubview(self.wStretchImageView)
        self.setPosition(.bottom, for: .hStretch)
        self.addSubview(self.hStretchImageView)
        self.setPosition(.bottomRight, for: .rotate)
        self.addSubview(self.rotateImageView)
        
        self.showEditingHandlers = true
        self.enableClose = true
        self.enableRotate = true
        self.enableWStretch = true
        self.enableHStretch = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Handler

    public func setImage(_ image: UIImage, for handler: DYStickerViewHandler) {
        switch handler {
        case .close:
            self.closeImageView.image = image
        case .rotate:
            self.rotateImageView.image = image
        case .hStretch:
            self.hStretchImageView.image = image
        case .wStretch:
            self.wStretchImageView.image = image
        }
    }
    
    public func setPosition(_ position: DYStickerViewHandlerPosition, for handler: DYStickerViewHandler) {
        let origin = self.contentView.frame.origin
        let size = self.contentView.frame.size
        
        var handlerView: UIImageView?
        
        switch handler {
        case .close:
            handlerView = self.closeImageView
        case .rotate:
            handlerView = self.rotateImageView
        case .hStretch:
            handlerView = self.hStretchImageView
        case .wStretch:
            handlerView = self.wStretchImageView
        }
        
        switch position {
        case .topLeft:
            handlerView?.center = origin
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        case .topRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        case .bottomLeft:
            handlerView?.center = CGPoint(x: origin.x, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
        case .bottomRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        case .top:
            handlerView?.center = CGPoint(x: origin.x + size.width / 2, y: origin.y)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        case .left:
            handlerView?.center = CGPoint(x: origin.x, y: origin.y + size.height / 2)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        case .right:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height / 2)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        case .bottom:
            handlerView?.center = CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        }
        
        handlerView?.tag = position.rawValue
    }
    
    public func setHandlerSize(_ size: Int) {
        guard size > 0 else { return }
        
        self.defaultInset = NSInteger(round(Float(size) / 2))
        self.defaultMinimumSize =  4 * self.defaultInset
        self.minimumSize = max(self.minimumSize, self.defaultMinimumSize)
        
        let originalCenter = self.center
        let originalTransform = self.transform
        var frame = self.contentView.frame
        frame = CGRect(x: 0, y: 0, width: frame.size.width + CGFloat(self.defaultInset) * 2, height: frame.size.height + CGFloat(self.defaultInset) * 2)
        
        self.contentView.removeFromSuperview()
        
        self.transform = .identity
        self.frame = frame
        
        self.contentView.center = centerPoint(self.bounds)
        self.addSubview(self.contentView)
        self.sendSubviewToBack(self.contentView)
        
        let handlerFrame = CGRect(x: 0,
                                  y: 0,
                                  width: self.defaultInset * 2,
                                  height: self.defaultInset * 2)
        self.closeImageView.frame = handlerFrame
        self.setPosition(DYStickerViewHandlerPosition(rawValue: closeImageView.tag) ?? .topLeft, for: .close)
        self.wStretchImageView.frame = handlerFrame
        self.setPosition(DYStickerViewHandlerPosition(rawValue: wStretchImageView.tag) ?? .right, for: .wStretch)
        self.hStretchImageView.frame = handlerFrame
        self.setPosition(DYStickerViewHandlerPosition(rawValue: hStretchImageView.tag) ?? .bottom, for: .hStretch)
        self.rotateImageView.frame = handlerFrame
        self.setPosition(DYStickerViewHandlerPosition(rawValue: rotateImageView.tag) ?? .bottomRight, for: .rotate)
        
        self.center = originalCenter
        self.transform = originalTransform
    }
    
    // MARK: - Actions
    
    @objc
    private func handleMoveGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        switch recognizer.state {
        case .began:
            self.beginningPoint = touchLocation
            self.beginningCenter = self.center
            delegate?.stickerView(self, didBeginMove: self.center)
        case .changed:
            self.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x),
                                  y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            delegate?.stickerView(self, didChangeMove: self.center)
        case .ended:
            self.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x),
                                  y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            delegate?.stickerView(self, didEndMove: self.center)
        default:
            break
        }
    }
    
    @objc
    private func handleRotateGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        let center = self.center
        
        switch recognizer.state {
        case .began:
            self.deltaAngle = CGFloat(atan2(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x)))
            delegate?.stickerView(self, didBeginRotate: self.deltaAngle)
        case .changed:
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff =  angle - Float(self.deltaAngle)
            self.transform = CGAffineTransform(rotationAngle: CGFloat(angleDiff))
            
            self.setNeedsDisplay()
            delegate?.stickerView(self, didChangeRotate: angle)
        case .ended:
            delegate?.stickerView(self, didChangeRotate: self.deltaAngle)
        default:
            break
        }
    }
    
    @objc
    private func handleWStretchGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        
        switch recognizer.state {
        case .began:
            self.initialBounds = self.bounds
            self.initialDistance = xDistance(point1: center, point2: touchLocation)
            delegate?.stickerView(self, didBeginWidth: self.bounds.width)
        case .changed:
            var scale = (xDistance(point1: center, point2: touchLocation) / self.initialDistance)
            let minimumScale = CGFloat(self.minimumSize) / self.initialBounds.size.width
            scale = max(scale, minimumScale)
            
            let scaleBounds = scaleValue(self.initialBounds, wScale: scale, hScale: 1.0)
            self.bounds = scaleBounds
            self.setNeedsDisplay()
            
            delegate?.stickerView(self, didChangeWidth: self.bounds.width)
        case .ended:
            delegate?.stickerView(self, didEndWidth: self.bounds.width)
        default:
            break
        }
    }
    
    @objc
    private func handleHStretchGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        
        switch recognizer.state {
        case .began:
            self.initialBounds = self.bounds
            self.initialDistance = yDistance(point1: center, point2: touchLocation)
            delegate?.stickerView(self, didBeginHeight: self.bounds.height)
        case .changed:
            var scale = yDistance(point1: center, point2: touchLocation) / self.initialDistance
            let minimumScale = CGFloat(self.minimumSize) / self.initialBounds.size.height
            scale = max(scale, minimumScale)
            
            let scaleBounds = scaleValue(self.initialBounds, wScale: 1.0, hScale: scale)
            self.bounds = scaleBounds
            self.setNeedsDisplay()
            
            delegate?.stickerView(self, didChangeHeight: self.bounds.height)
        case .ended:
            delegate?.stickerView(self, didEndHeight: self.bounds.height)
        default:
            break
        }
    }
    
    @objc
    private func handleCloseGesture(_ recognizer: UITapGestureRecognizer) {
        delegate?.stickerView(self, didTapClose: true)
        self.removeFromSuperview()
    }
    
    @objc
    private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        delegate?.stickerView(self, didTapSticker: true)
    }
}

//MARK: -Properties

public extension DYStickerView {
    var minimumSize: NSInteger {
        get {
            return _minimumSize
        }
        set {
            _minimumSize = max(newValue, self.defaultMinimumSize)
        }
    }
    
    var outlineBorderColor: UIColor {
        get {
            return _outlineBorderColor
        }
        set {
            _outlineBorderColor = newValue
            self.contentView?.layer.borderColor = _outlineBorderColor.cgColor
        }
    }
}

//MARK: -Private Method

private extension DYStickerView {
    func centerPoint(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    func scaleValue(_ rect: CGRect, wScale: CGFloat, hScale: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x,
                      y: rect.origin.y,
                      width: rect.size.width * wScale,
                      height: rect.size.height * hScale)
    }
    
    // CGAffineTransform -> 객체를 회전, 크기 조절, 변환 또는 기울기를 위해 사용됨
    // 해당 함수는 기울기 각도를 get하기 위해 만든 것
    func angleValue(_ t: CGAffineTransform) -> CGFloat {
        return atan2(t.b, t.a)
    }
    
    func yDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return point2.y - point1.y
    }
    
    func xDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return point2.x - point1.x
    }
    
    func setEnableClose(_ enableClose: Bool) {
        self.closeImageView.isHidden = !enableClose
        self.closeImageView.isUserInteractionEnabled = enableClose
    }
    
    func setEnableRotate(_ enableClose: Bool) {
        self.rotateImageView.isHidden = !enableClose
        self.rotateImageView.isUserInteractionEnabled = enableClose
    }
    
    func setEnableWStretch(_ enableClose: Bool) {
        self.wStretchImageView.isHidden = !enableClose
        self.wStretchImageView.isUserInteractionEnabled = enableClose
    }
    
    func setEnableHStretch(_ enableClose: Bool) {
        self.hStretchImageView.isHidden = !enableClose
        self.hStretchImageView.isUserInteractionEnabled = enableClose
    }
}

// MARK: - Gesture Delegate

extension DYStickerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
