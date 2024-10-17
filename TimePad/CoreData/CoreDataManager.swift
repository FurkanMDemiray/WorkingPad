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

    func createWork(id: String, title: String, hour: Int, minute: Int, seconds: Int, type: String) {
        let work = Work(context: context)
        work.id = id
        work.title = title
        work.hour = Int16(hour)
        work.minute = Int16(minute)
        work.seconds = Int16(seconds)
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

    func updateWork(by id: String, newTitle: String, newHour: Int, newMinute: Int, newSeconds: Int, newType: String) {
        let fetchRequest: NSFetchRequest<Work> = Work.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let works = try context.fetch(fetchRequest)
            if let workToUpdate = works.first {
                workToUpdate.title = newTitle
                workToUpdate.hour = Int16(newHour)
                workToUpdate.minute = Int16(newMinute)
                workToUpdate.seconds = Int16(newSeconds)
                workToUpdate.type = newType
                saveContext()
                print("Work updated successfully")
            } else {
                print("No work found with this id")
            }
        } catch let error {
            print("Update error: \(error)")
        }
    }

    func deleteWork(work: Work) {
        context.delete(work)
        saveContext()
    }
}
