//
//  FirebaseStorage.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/11.
//

import Foundation
import Firebase
import RxSwift

class DYSticker {
    static let shared = DYSticker()

    private let storage = Storage.storage()

    // temp
    private var stickerList: [String] = []

    init() {
        loadStickerList()
        loadFreeImages()
        loadPremiumImages()
    }

    private func loadStickerList() {

    }

    private func loadFreeImages() {
//        loadImages.observe(on: )
        let reference = storage.reference().child("free/")
        reference.listAll { result, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            result.prefixes.forEach { prefix in
                print("Prefix: \(prefix)")
            }

            result.items.forEach { item in
                print("Item: \(item)")
                item.downloadURL { url, error in
                    guard let url = url else { return }
                    print("url: \(url)")
                }
            }
        }
    }

    private func loadPremiumImages() {

    }
}
