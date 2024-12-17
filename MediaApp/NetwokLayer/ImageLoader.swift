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
                      completion: @escaping (Result<UIImage, NetworkError>) -> Void)
}

final class ImageLoader: ImageLoadingProtocol {
    func downloadData(by urlString: String,
                      completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.missingData))
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                completion(.success(image))
                
            case .failure(let error):
                completion(.failure(.missingURL))
            }
        }
    }
}
