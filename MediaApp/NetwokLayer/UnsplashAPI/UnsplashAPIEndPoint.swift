//
//  UnsplashAPIEndPoint.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

enum UnsplashAPIEndPoint {
    case photo(id: String)
    case randomPhotos(count: Int)
    case search(keyword: String, page: Int)
}

extension UnsplashAPIEndPoint: EndPointType {
    var baseUrl: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        
        return urlComponents.url
    }
    
    var path: String {
        switch self {
        case .photo(let id):
            return "photos/\(id)"
            
        case .randomPhotos(_):
            return "photos/random"
            
        case .search(_, _):
            return "search/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "client_id",
                                       value: "gcyLclpfLTSlIk-e7vBGTepxQ_5AMlYT73B0_9Xo3Cc"))
        
        switch self {
        case .randomPhotos(let count):
            queryItems.append(URLQueryItem(name: "count",
                                           value: String(count)))
            
        case .search(let keyword, let page):
            queryItems.append(URLQueryItem(name: "page",
                                           value: String(page)))
            queryItems.append(URLQueryItem(name: "per_page",
                                           value: String(20)))
            queryItems.append(URLQueryItem(name: "query",
                                           value: keyword))
            
        default:
            return queryItems
        }
        
        return queryItems
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
}
