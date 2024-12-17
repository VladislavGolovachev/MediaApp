//
//  PhotoEntity+CoreDataProperties.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//
//

import Foundation
import CoreData

extension PhotoEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var id: String?
    @NSManaged public var location: String?
    @NSManaged public var downloads: Int32
}

extension PhotoEntity : Identifiable {

}
