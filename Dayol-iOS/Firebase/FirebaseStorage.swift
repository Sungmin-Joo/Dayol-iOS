//
//  FirebaseStorage.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/11.
//

import Foundation
import Firebase
import RxSwift

class FirebaseStorage {
    static let shared = FirebaseStorage()

    private let storage = Storage.storage()
    
    init() {
        loadFreeImages()
    }

    func loadImages() {
        loadFreeImages()
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
}
