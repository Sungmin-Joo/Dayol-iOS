//
//  DYStickerBaseView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/28.
//

import UIKit

public class DYStickerBaseView: DYStickerView {
    override init(contentView: UIView) {
        super.init(contentView: contentView)
        self.enableClose = true
        self.enableRotate = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
