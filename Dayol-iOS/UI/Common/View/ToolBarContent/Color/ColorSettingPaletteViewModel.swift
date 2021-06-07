//
//  ColorSettingPaletteViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/07.
//

import Foundation
import Combine

struct ColorSettingPaletteViewModel {
    let currentHexColor = CurrentValueSubject<String, Never>("#FFFFFF")
    var paletteColors = CurrentValueSubject<[DYPaletteColor], Never>(DYPaletteColor.penColorPreset)

    init() {
        archivePaletteColors()
    }
}

private extension ColorSettingPaletteViewModel {

    func archivePaletteColors() {
        // db에 저장된 컬러를 get
        // paletteColors.send(archivedPaletteColors)
    }

}
