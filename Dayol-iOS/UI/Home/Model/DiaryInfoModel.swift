//
//  DiaryCoverModel.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import UIKit

// TODO: - 커버 꾸미기에 필요한 데이터로 모델 구현
struct DiaryInfoModel {
    let id: String
    let colorHex: String
    let title: String
    let totalPage: Int
    let password: String?

    init(id: String, color: DiaryCoverColor, title: String, totalPage: Int, password: String?) {
        self.id = id
        self.colorHex = color.hexString
        self.title = title
        self.totalPage = totalPage
        self.password = password
    }

}
