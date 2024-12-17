//
//  Storage.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation
import CoreData

final class Storage: CoreDataStorage {
    private var _loadingError: StorageError?
    var loadingError: StorageError? {
        return _loadingError
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MediaModel")
        container.loadPersistentStores { [weak self] _, error in
            if let error {
                self?._loadingError = .unableToLoadData
            }
        }
        
        return container
    }()
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        return context
    }()
}
