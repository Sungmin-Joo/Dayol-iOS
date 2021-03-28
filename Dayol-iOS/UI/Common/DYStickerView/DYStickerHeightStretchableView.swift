//
//  DYStickerHeightStretchableView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/28.
//

import UIKit

final class DYStickerHeightStretchableView: DYStickerBaseView {
    override init(contentView: UIView) {
        super.init(contentView: contentView)
        self.enableHStretch = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
