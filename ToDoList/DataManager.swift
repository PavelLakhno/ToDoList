//
//  DataManager.swift
//  ToDoList
//
//  Created by user on 18.11.2022.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(tasks)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func create(_ taskTitle: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskTitle
        completion(task)
        saveContext()
    }
    
    func update(_ task: Task, title: String) {
        task.title = title
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
