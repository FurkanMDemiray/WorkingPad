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

    //MARK: Create
    func createLastWork(title: String, hour: Int, minute: Int, seconds: Int, type: String) {
        // if there is no last work, create one, otherwise update it
        if fetchLastWork() == nil {
            let lastWork = LastWork(context: context)
            lastWork.title = title
            lastWork.hour = Int16(hour)
            lastWork.minute = Int16(minute)
            lastWork.seconds = Int16(seconds)
            lastWork.type = type
            saveContext()
        }
        else {
            updateLastWork(newTitle: title, newHour: hour, newMinute: minute, newSeconds: seconds, newType: type)
        }
    }

    func createWork(id: String, title: String, hour: Int, minute: Int, seconds: Int, type: String) {
        let work = Work(context: context)
        work.id = id
        work.title = title
        work.hour = Int16(hour)
        work.minute = Int16(minute)
        work.seconds = Int16(seconds)
        work.firstHour = Int16(hour)
        work.firstMinute = Int16(minute)
        work.type = type
        saveContext()
    }

    //MARK: Fetch
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

    func fetchLastWork() -> LastWork? {
        let fetchRequest: NSFetchRequest<LastWork> = LastWork.fetchRequest()
        do {
            let lastWorks = try context.fetch(fetchRequest)
            return lastWorks.first
        } catch let error {
            print("Fetch error: \(error)")
            return nil
        }
    }

    //MARK: Update
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

    func updateLastWork(newTitle: String, newHour: Int, newMinute: Int, newSeconds: Int, newType: String) {
        let fetchRequest: NSFetchRequest<LastWork> = LastWork.fetchRequest()

        do {
            let lastWorks = try context.fetch(fetchRequest)
            if let lastWorkToUpdate = lastWorks.first {
                lastWorkToUpdate.title = newTitle
                lastWorkToUpdate.hour = Int16(newHour)
                lastWorkToUpdate.minute = Int16(newMinute)
                lastWorkToUpdate.seconds = Int16(newSeconds)
                lastWorkToUpdate.type = newType
                saveContext()
                print("Last work updated successfully")
            } else {
                print("No last work found")
            }
        } catch let error {
            print("Update error: \(error)")
        }
    }

    //MARK: Delete
    func deleteWork(work: Work) {
        context.delete(work)
        saveContext()
    }

    func deleteLastWork(lastWork: LastWork) {
        context.delete(lastWork)
        saveContext()
    }
}
