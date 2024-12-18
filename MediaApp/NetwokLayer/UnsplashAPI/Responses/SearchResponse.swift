//
//  SearchResponse.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [BasicPhotoResponse]
}

struct BasicPhotoResponse: Decodable {
    let id: String
    let urls: URLPhoto
}
