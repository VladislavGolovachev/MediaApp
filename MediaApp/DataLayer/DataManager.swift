//
//  DataManager.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation
import CoreData

protocol DataManagerProtocol: CoreDataStorageManager {
    
}

//MARK: CoreDataStorageManager
final class DataManager: DataManagerProtocol {
    typealias KeyType = Date
    typealias ObjectType = PhotoEntity
    
    private let storage: CoreDataStorage = Storage()
        
    func fetch(amongObjectsWithKeyedValues: [String : Any]?) throws -> [PhotoEntity] {
        return [PhotoEntity]()
    }
    
    func persist(with keyedValues: [String : Any]) throws {
        
    }
    
    func delete(for: Date, amongObjectsWithKeyedValues: [String : Any]?) throws {
        
    }
}
