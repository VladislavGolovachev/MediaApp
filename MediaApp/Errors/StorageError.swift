//
//  StorageError.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

enum StorageError: String, Error {
    case unableToLoadData   = "Unable to load persistent stores"
    case missingObject      = "There is no fetched object"
    case fetchingFailed     = "Error caused during fetching"
    case unableToSaveData   = "Unable to save data"
    case unknown            = "An unknown storage error caused"
}
