//
//  Data+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/30.
//

import Foundation

extension Data {
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        return JSONDecoder().decodeWithoutThrow(type, from: self)
    }
}
