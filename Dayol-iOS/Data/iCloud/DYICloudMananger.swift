//
//  DYiCloud.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/13.
//

import Foundation

class DYICloudMananger {
    enum Document: String, CaseIterable {
        case coreData = "CoreData"
    }

    static let shared = DYICloudMananger()
    private(set) var containerURL: [Document: URL?] = [:]

    init() {
        configureContainers()
    }

    private func configureContainers() {
        Document.allCases.forEach {
            containerURL[$0] = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent($0.rawValue)
        }

        containerURL.forEach { key, url in
            guard let url = url else {
                DYLog.e(.iCloud, value: "Invalid URL")
                return
            }
            createDirectoryIfNeeded(url, isFileExistes: FileManager.default.fileExists(atPath: url.path))
            DYLog.d(.iCloud, value: "Path: \(url.path)")
        }
    }

    private func createDirectoryIfNeeded(_ url: URL, isFileExistes: Bool) {
        if !isFileExistes {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                DYLog.e(.iCloud, value: error.localizedDescription)
            }
        }
    }

    func syncDocuments() {}
}
