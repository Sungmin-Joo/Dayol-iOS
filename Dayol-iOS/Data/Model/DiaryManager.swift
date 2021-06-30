//
//  DiaryManager.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/29.
//

import Foundation
import RxSwift
import CoreData

class DiaryManager {
    static let shared = DiaryManager()
    let diaryListSubject = BehaviorSubject<[Diary]>(value: [])

    private init() {
        fetchDiaryList()
    }
}

// MARK: - Create

extension DiaryManager {
    func createDiary(_ diary: Diary) {
        let context = PersistentManager.shared.context
        let entity = PersistentManager.shared.entity(.diary)

        if let entity = entity {
            let diaryMO = DiaryMO(entity: entity, insertInto: context)
            diaryMO.set(diary)
            addContents(to: diaryMO, items: diary.contents)
            PersistentManager.shared.saveContext()
            fetchDiaryList()
        }
    }
}

// MARK: - Retrieve

extension DiaryManager {

    func fetchDiaryList() {
        let fetchRequest: NSFetchRequest<DiaryMO> = DiaryMO.fetchRequest()

        guard let result = PersistentManager.shared.fetch(fetchRequest) else {
            return
        }

        let diaryList = result.compactMap { $0.getDiary() }
        diaryListSubject.onNext(diaryList)
    }

    func fetchDiary(id: String) -> Diary? {
        guard let diaryMO = getDiaryMO(id: id) else {
            return nil
        }
        return diaryMO.getDiary()
    }

}

// MARK: Update

extension DiaryManager {

    func updateDiary(_ diary: Diary) {
        guard let diaryMO = getDiaryMO(id: diary.id) else { return }

        diaryMO.set(diary)
        addContents(to: diaryMO, items: diary.contents)
        PersistentManager.shared.saveContext()
        fetchDiaryList()
    }

}

// MARK: - Delete

extension DiaryManager {

    func deleteDiary(id: String) {
        guard let diaryMO = getDiaryMO(id: id) else { return }
        let context = PersistentManager.shared.context
        context.delete(diaryMO)
        PersistentManager.shared.saveContext()
        fetchDiaryList()
    }

}

// MARK: - Util

extension DiaryManager {

    private func getDiaryMO(id: String) -> DiaryMO? {
        let fetchRequest: NSFetchRequest<DiaryMO> = DiaryMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        guard let result = PersistentManager.shared.fetch(fetchRequest) else {
            return nil
        }

        return result.first
    }

    private func addContents(to diaryMO: DiaryMO, items: [DecorationItem]) {
        items.forEach {
            // TODO: - 상속 구조로 다듬을 수 없는지?

            if let textFieldItem = $0 as? DecorationTextFieldItem {
                // DecorationTextFieldItem
                let managedObject = PersistentManager.shared.insertNewObject(.decorationTextFieldItem)

                guard let textFieldItemMO = managedObject as? DecorationTextFieldItemMO else { return}

                textFieldItemMO.set(textFieldItem)
                diaryMO.addToContents(textFieldItemMO)
            } else if let imageItem = $0 as? DecorationImageItem {
                // DecorationImageItem
            } else if let sticker = $0 as? DecorationStickerItem {
                // DecorationStickerItem
            }
        }
    }
}
