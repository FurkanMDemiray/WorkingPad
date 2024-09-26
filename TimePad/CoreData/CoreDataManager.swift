//
//  CoreDataManager.swift
//  TimePad
//
//  Created by Melik Demiray on 26.09.2024.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func createWork(title: String, hour: Int, minute: Int, type: String) {
        let work = Work(context: context)
        work.title = title
        work.hour = Int16(hour)
        work.minute = Int16(minute)
        work.type = type
        saveContext()
    }

    func fetchWorks() -> [Work] {
        let fetchRequest: NSFetchRequest<Work> = Work.fetchRequest()
        do {
            let works = try context.fetch(fetchRequest)
            return works
        } catch let error {
            print("Fetch error: \(error)")
            return []
        }
    }

    func updateWork(work: Work, newTitle: String, newHour: Int, newMinute: Int, newType: String) {
        work.title = newTitle
        work.hour = Int16(newHour)
        work.minute = Int16(newMinute)
        work.type = newType
        saveContext()
    }

    func deleteWork(work: Work) {
        context.delete(work)
        saveContext()
    }
}
