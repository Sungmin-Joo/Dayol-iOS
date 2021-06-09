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
    var paletteColors = CurrentValueSubject<[DYPaletteColor], Never>(DYPaletteColor.colorPreset)

    init() {
        archivePaletteColors()
    }
}

// MARK: - Public

extension ColorSettingPaletteViewModel {

    func addCustomColor(_ color: DYPaletteColor) {
        var newPaletteColors = paletteColors.value
        newPaletteColors.append(color)
        paletteColors.send(newPaletteColors)
    }

    func removeCustomColor(_ color: DYPaletteColor) {
        var newPaletteColors = paletteColors.value
        guard let index = newPaletteColors.firstIndex(of: color) else { return }
        newPaletteColors.remove(at: index)
        paletteColors.send(newPaletteColors)
    }

}

private extension ColorSettingPaletteViewModel {

    func archivePaletteColors() {
        // db에 저장된 컬러를 get
        // paletteColors.send(archivedPaletteColors)
    }

}
