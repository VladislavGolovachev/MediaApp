//
//  ImageLoader.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Kingfisher
import Foundation

protocol ImageLoadingProtocol {
    func downloadData(by urlString: String,
                      completion: (Result<Data, NetworkError>) -> Void)
}

final class ImageLoader: ImageLoadingProtocol {
    func downloadData(by urlString: String,
                      completion: (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.missingData))
            return
        }
        
        
//        completion(.success(data))
    }
}
