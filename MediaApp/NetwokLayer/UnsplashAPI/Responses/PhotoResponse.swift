//
//  PhotoResponse.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

struct PhotoResponse: Decodable {
    let creationDate: Date
    let downloads: String
    let user: User
    let urls: [URLPhoto]
    
    private enum CodingKeys: String, CodingKey {
        case creationDate = "created_at"
        case downloads = "downloads"
        case user = "user"
        case urls = "urls"
    }
}
