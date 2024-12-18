//
//  DataManager.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation
import CoreData

//MARK: CoreDataStorageManager
final class DataManager: CoreDataStorageManager {
    typealias KeyType = String
    typealias ObjectType = PhotoEntity
    
    private let storage: CoreDataStorage = Storage()
        
    func fetch(for id: String) throws -> [PhotoEntity] {
        var photos: [PhotoEntity]?
        try storage.backgroundContext.performAndWait { [weak self] in
            guard let strongSelf = self else {
                throw StorageError.unknown
            }
            if let error = strongSelf.storage.loadingError {
                throw error
            }
            
            let request = PhotoEntity.fetchRequest()

            let sortDescriptor = NSSortDescriptor(key: PhotoKeys.creationDate.rawValue,
                                                  ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            let key = PhotoKeys.id.rawValue
            let predicate = NSPredicate(format: "\(key) = %@", id)
            request.predicate = predicate
            
            do {
                photos = try strongSelf.storage.backgroundContext.fetch(request)
            } catch {
                throw StorageError.fetchingFailed
            }
        }
        
        if let photos {
            return photos
        }
        throw StorageError.missingObject
    }
    
    func persist(with keyedValues: [String: Any]) throws {
        try storage.backgroundContext.performAndWait { [weak self] in
            if let error = self?.storage.loadingError {
                throw error
            }
            guard let context = self?.storage.backgroundContext,
                  let entity = NSEntityDescription.entity(forEntityName: "PhotoEntity",
                                                          in: context) else {return}
            
            let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValuesForKeys(keyedValues)
            
            try self?.saveContext()
        }
    }
    
    func delete(for id: String) throws {
        try storage.backgroundContext.performAndWait { [weak self] in
            guard let strongSelf = self else {
                throw StorageError.unknown
            }
            let photos = try strongSelf.fetch(for: id)
            
            strongSelf.storage.backgroundContext.delete(photos[0])
            try strongSelf.saveContext()
        }
    }
}

extension DataManager {
    private func saveContext() throws {
        try storage.backgroundContext.performAndWait { [weak self] in
            do {
                try self?.storage.backgroundContext.save()
            } catch {
                throw StorageError.unableToSaveData
            }
        }
    }
}
