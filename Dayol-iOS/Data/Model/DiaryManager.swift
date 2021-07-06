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
    var diaryList: [Diary] = []
    let needsUpdateDiaryList = ReplaySubject<Void>.createUnbounded()

    private init() {
        fetchDiaryList()
    }
}

// MARK: - Create

extension DiaryManager {
    func createDiary(_ diary: Diary) {
        guard let diaryMO = PersistentManager.shared.managedObject(.diary, class: DiaryMO.self) else {
            return
        }

        diaryMO.make(diary: diary)
        addContents(to: diaryMO, items: diary.contents)
        PersistentManager.shared.saveContext()
        fetchDiaryList()
    }
}

// MARK: - Retrieve

extension DiaryManager {

    func fetchDiaryList() {
        let fetchRequest: NSFetchRequest<DiaryMO> = DiaryMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        guard let result = PersistentManager.shared.fetch(fetchRequest) else {
            return
        }

        let diaryList = result.compactMap { $0.toModel }
        self.diaryList = diaryList
        needsUpdateDiaryList.onNext(())
    }

    func fetchDiary(id: String) -> Diary? {
        guard let diaryMO = getDiaryMO(id: id) else {
            return nil
        }
        return diaryMO.toModel
    }

}

// MARK: Update

extension DiaryManager {

    func updateDiary(_ diary: Diary) {
        guard let diaryMO = getDiaryMO(id: diary.id) else { return }

        diaryMO.make(diary: diary)
        addContents(to: diaryMO, items: diary.contents)
        PersistentManager.shared.saveContext()
    }

    func updateDiaryOrder(at sourceIndex: Int, to destinationIndex: Int) {
        guard
            var sourceModel = diaryList[safe: sourceIndex],
            var destinationModel = diaryList[safe: destinationIndex]
        else { return }

        if sourceIndex > destinationIndex {
            diaryList.remove(at: sourceIndex)
            diaryList.insert(sourceModel, at: destinationIndex)
        } else {
            diaryList.insert(sourceModel, at: destinationIndex + 1)
            diaryList.remove(at: sourceIndex)
        }

        sourceModel.index = Int32(destinationIndex)
        destinationModel.index = Int32(sourceIndex)

        updateDiary(sourceModel)
        updateDiary(destinationModel)

        // reorder의 ui 인터랙션은 collectionView api에서 해결해주기때문에 따로 fetch 하지 않는다.
    }

}

// MARK: - Delete

extension DiaryManager {

    func deleteDiary(id: String) {
        guard
            let diary = diaryList.first(where: { $0.id == id }),
            let diaryMO = getDiaryMO(id: id)
        else { return }

        let targetIndex = diary.index

        diaryList.enumerated().forEach { index, diary in
            guard index > targetIndex else { return }
            diaryList[index].index = Int32(index - 1)
            updateDiary(diaryList[index])
        }

        PersistentManager.shared.deleteManagedObject(diaryMO)
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
                let managedObject = PersistentManager.shared.insertObject(.decorationTextFieldItem)

                guard let textFieldItemMO = managedObject as? DecorationTextFieldItemMO else { return}

                textFieldItemMO.make(item: textFieldItem)
                diaryMO.addToContents(textFieldItemMO)
            } else if let imageItem = $0 as? DecorationImageItem {
                // DecorationImageItem
            } else if let sticker = $0 as? DecorationStickerItem {
                // DecorationStickerItem
            }
        }
    }
}
