//
//  PhotoInfo.swift
//  MediaApp
//
//  Created by Владислав Головачев on 18.12.2024.
//

import UIKit

struct PhotoInfo {
    let image: UIImage
    let author: String
    let downloads: String
    private let location: String
    private let date: String
    var locationDate: String {
        return location + " (\(date))"
    }
    
    init(image: UIImage,
         author: String?,
         downloads: Int,
         location: String?,
         date: String?) {
        self.image = image
        self.author = "Author: " + (author ?? "Author not stated")
        self.downloads = "Downloads: " + String(downloads)
        self.location = location ?? "Location not stated"
        self.date = date ?? "date not stated"
    }
}
