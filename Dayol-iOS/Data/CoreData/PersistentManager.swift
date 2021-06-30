//
//  PersistentManager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/13.
//

import Foundation
import CoreData

class PersistentManager {
    enum EntityType {
        case diary
        case paper
        case paperScheduler
        case decorationItem
        case decorationTextFieldItem

        var name: String {
            switch self {
            case .diary: return "Diary"
            case .paper: return "Paper"
            case .paperScheduler: return "PaperScheduler"
            case .decorationItem: return "DecorationItem"
            case .decorationTextFieldItem: return "DecorationTextFieldItem"
            }
        }
    }
    static let shared: PersistentManager = PersistentManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Dayol")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                DYLog.e(.coreData, value: "Unresolved Error \(error) | \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let error = error as NSError
                DYLog.e(.coreData, value: "Unresolved Error \(error) | \(error.userInfo)")
            }
        }
    }

    func entity(_ type: EntityType) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: type.name, in: persistentContainer.viewContext)
    }

    func insertObject(_ type: EntityType) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: type.name, into: persistentContainer.viewContext)
    }
}

extension NSManagedObject {
    static func fetchRequest<T: NSManagedObject>() -> NSFetchRequest<T>? {
        guard let name = entity().name else { return nil }
        return NSFetchRequest<T>(entityName: name)
    }
}

// MARK: - Fetch

extension PersistentManager {

    func fetch<T: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try context.fetch(fetchRequest)
            return result
        }
        catch {
            let error = error as NSError
            DYLog.e(.coreData, value: "Fetch Error \(error) | \(error.userInfo)")
            return nil
        }
    }
}
