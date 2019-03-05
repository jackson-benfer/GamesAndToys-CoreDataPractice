//
//  CoreDataService.swift
//  CoreDataSuperExample
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation
import CoreData

/*
 Core Data Stack
 (top to bottom)
 1. NSManagedObjectContext(m)  - Context
 2. PersistStoreCoordinator(s) - Coordinator(?)
 3. PersistentContainer(s)
 4. NSManagedObjects(m)        - Core Data Items/Entities/Objects
 */

class CoreDataService {
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataSuperExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func loadAllEntities<T: NSManagedObject>(named: String) -> [T] {
        
        let fetchRequest = NSFetchRequest<T>(entityName: named)
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        }
        catch {
            print("Error in loading from file")
        }
        return []
    }
    
    
    func deleteObject(_ o: NSManagedObject) {
       
        context.delete(o)
        saveContext()
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension CoreDataService {
    
    //TODO: Code for Queries
    
    func findAllEntities<T: NSManagedObject>(named: String, searchFor: String) -> [T] {
        
        let fetchRequest = NSFetchRequest<T>(entityName: named)
        
        let predicate = NSPredicate.init(format: "name CONTAINS %@", searchFor)
        fetchRequest.predicate = predicate
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        }
        catch {
            print("Error in loading from file")
        }
        return []
    }
}
