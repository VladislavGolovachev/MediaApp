//
//  CoreDataStorageProtocols.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation
import CoreData

protocol CoreDataStorage {
    var loadingError: StorageError? {get}
    var persistentContainer: NSPersistentContainer {get}
    var backgroundContext: NSManagedObjectContext {get}
}

protocol CoreDataStorageManager {
    associatedtype ObjectType: NSManagedObject
    
    func fetch(for: String) throws -> [ObjectType]
    func persist(with keyedValues: [String: Any]) throws
    func delete(for: String) throws
}
