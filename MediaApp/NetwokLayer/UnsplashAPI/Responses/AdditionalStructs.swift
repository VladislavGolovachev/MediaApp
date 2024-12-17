//
//  AdditionalStructs.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

struct URLPhoto: Decodable {
    let regular: String
}

struct User: Decodable {
    let name: String
    let location: String?
}
