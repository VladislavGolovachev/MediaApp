//
//  NetworkManager.swift
//  MediaApp
//
//  Created by Владислав Головачев on 17.12.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func getPhotos(count: Int,
                   completion: @escaping (Result<[BasicPhotoResponse], NetworkError>) -> Void)
    func getPhotoInfo(id: String,
                      completion: @escaping (Result<PhotoResponse, NetworkError>) -> Void)
    func searchPhotos(keyword: String,
                      completion: @escaping (Result<[BasicPhotoResponse], NetworkError>) -> Void)
}

//MARK: NetworkManagerProtocol
struct NetworkManager: NetworkManagerProtocol {
    private let router = NetworkRouter<UnsplashAPIEndPoint>()
    
    func getPhotos(count: Int,
                   completion: @escaping (Result<[BasicPhotoResponse], NetworkError>) -> Void) {
        router.request(.randomPhotos(count: count)) { data, response, error in
            if error != nil {
                completion(.failure(.networkConnection))
                return
            }
            if let response, let possibleError = handleURLResponse(response) {
                completion(.failure(possibleError))
                return
            }
            guard let data else {
                completion(.failure(.missingData))
                return
            }
            
            do {
                let randomPhotos = try JSONDecoder().decode([BasicPhotoResponse].self,
                                                            from: data)
                completion(.success(randomPhotos))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
    }
    
    func getPhotoInfo(id: String,
                      completion: @escaping (Result<PhotoResponse, NetworkError>) -> Void) {
        router.request(.photo(id: id)) { data, response, error in
            if error != nil {
                completion(.failure(.networkConnection))
                return
            }
            if let response, let possibleError = handleURLResponse(response) {
                completion(.failure(possibleError))
                return
            }
            guard let data else {
                completion(.failure(.missingData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(PhotoResponse.self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
    }
    
    func searchPhotos(keyword: String,
                      completion: @escaping (Result<[BasicPhotoResponse], NetworkError>) -> Void) {
        router.request(.search(keyword: keyword)) { data, response, error in
            if error != nil {
                completion(.failure(.networkConnection))
                return
            }
            if let response, let possibleError = handleURLResponse(response) {
                completion(.failure(possibleError))
                return
            }
            guard let data else {
                completion(.failure(.missingData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(SearchResponse.self,
                                                           from: data)
                completion(.success(apiResponse.results))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
    }
}

//MARK: - Private Functions
extension NetworkManager {
    private func handleURLResponse(_ response: URLResponse) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return nil
        case 400...499:
            return .clientProblem
        case 500...599:
            return .serverProblem
        case 600:
            return .outdatedRequest
        default:
            return .unknown
        }
    }
}
