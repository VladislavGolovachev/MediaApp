//
//  SearchResponse.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [SearchPhoto]
}

struct SearchPhoto: Decodable {
    let creationDate: Date
    let user: User
    let urls: [URLPhoto]
    
    private enum CodingKeys: String, CodingKey {
        case creationDate = "created_at"
        case user = "user"
        case urls = "urls"
    }
}

struct URLPhoto: Decodable {
    let regular: String
}

struct User: Decodable {
    let name: String
    let location: String?
}
