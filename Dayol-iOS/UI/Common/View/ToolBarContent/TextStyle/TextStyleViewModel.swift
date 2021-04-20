//
//  TextStyleViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/04.
//

import Foundation

struct TextStyleViewModel {
    let alignment:TextStyleModel.Alignment
    let textSize: Int
    let additionalOptions: [TextStyleModel.AdditionalOption]
    let lineSpacing: Int
    let font: TextStyleModel.Font
}
