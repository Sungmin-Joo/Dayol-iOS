//
//  JSONDecoder+Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/30.
//

import Foundation

extension JSONDecoder {
    func decodeWithoutThrow<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable {
        do {
            return try decode(type, from: data)
        }
        catch {
            return nil
        }
    }
}
