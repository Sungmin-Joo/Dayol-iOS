//
//  HRColorCursor.swift
//  ColorPicker3
//
//  Created by Hayashi Ryota on 2019/02/16.
//  Copyright © 2019 Hayashi Ryota. All rights reserved.
//

import UIKit

internal class ColorMapCursor: UIView {
    
    private let backgroundLayer = CALayer()
    private let colorLayer = CALayer()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = false
        backgroundLayer.shadowColor = UIColor.black.cgColor
        backgroundLayer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundLayer.shadowRadius = 3
        backgroundLayer.shadowOpacity = 0.5
        backgroundLayer.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(colorLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let backgroundSize = CGSize(width: 24, height: 24)
        backgroundLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        backgroundLayer.bounds = CGRect(origin: .zero, size: backgroundSize)
        backgroundLayer.cornerRadius = backgroundSize.width/2
        
        let colorSize = CGSize(width: 22, height: 22)
        colorLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        colorLayer.bounds = CGRect(origin: .zero, size: colorSize)
        colorLayer.cornerRadius = colorSize.width/2
    }
    
    func set(hsvColor: HSVColor) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        colorLayer.backgroundColor = hsvColor.uiColor.cgColor
        CATransaction.commit()
    }

}
