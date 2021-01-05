//
//  DiaryEditCoverView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let maximumZoomIn: CGFloat = 3.0
    static let minimumZoomOut: CGFloat = 1.0
    
    static let coverCenterY: CGFloat = 30.0
    
    static let zoomLabelBottom: CGFloat = 30.0
    static let zoomLabelFont = UIFont.appleMedium(size: 14)
    static let zoomLabelTextColor: UIColor = UIColor(decimalRed: 153, green: 153, blue: 153)
    static let zoomLabelSpace: CGFloat = -0.26
}

private enum Text {
    static let zoomText = "두 손으로 확대/축소 할 수 있어요!"
}

class DiaryEditCoverView: UIView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = Design.minimumZoomOut
        scrollView.maximumZoomScale = Design.maximumZoomIn
        
        return scrollView
    }()
    
    private let zoomLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Design.zoomLabelFont,
            .kern: Design.zoomLabelSpace
        ]
        let attributedText = NSMutableAttributedString(string: Text.zoomText, attributes: attributes)
        label.textColor = Design.zoomLabelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = attributedText
        label.sizeToFit()
        
        return label
    }()
    
    private let diaryView: DiaryView = {
        let view = isPadDevice ? DiaryView(type: .big) : DiaryView(type: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCover(color: .DYBrown)
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        scrollView.delegate = self
        scrollView.addSubview(diaryView)
        addSubview(scrollView)
        addSubview(zoomLabel)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            
            diaryView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            diaryView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -Design.coverCenterY),
            
            zoomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            zoomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.zoomLabelBottom)
        ])
    }
}

extension DiaryEditCoverView {
    func setCoverColor(color: DiaryCoverColor) {
        diaryView.setCover(color: color)
    }
    
    func setDayolLogoHidden(_ isHidden: Bool) {
        diaryView.setDayolLogoHidden(isHidden)
    }
}

extension DiaryEditCoverView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return diaryView
    }
}
