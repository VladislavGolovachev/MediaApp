//
//  RandomPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit
import Kingfisher

//MARK: RandomViewProtocol
protocol RandomViewProtocol: AnyObject {
    func updateCollection(count: Int)
    func setImage(_: UIImage, for: IndexPath)
    
    func showAlert(title: String, message: String)
}

//MARK: - RandomViewPresenterProtocol
protocol RandomViewPresenterProtocol: AnyObject {
    init(view: RandomViewProtocol,
         router: RouterProtocol,
         imageLoader: ImageLoadingProtocol,
         networkManager: NetworkManagerProtocol)
    
    func showDetailedInfo()
    func fetchImages(isNewList: Bool)
    func downloadImage(for: IndexPath)
    func searchFor(_: String)
}

//MARK: - RandomPresenter
final class RandomPresenter: RandomViewPresenterProtocol {
    //MARK: -Variables
    weak var view: RandomViewProtocol?
    var router: RouterProtocol
    var networkManager: NetworkManagerProtocol
    var imageLoader: ImageLoadingProtocol?
    
    private var photos: [PhotoModel]?
    
    //MARK: RandomViewPresenterProtocol's Implementation
    init(view: RandomViewProtocol,
         router: RouterProtocol,
         imageLoader: ImageLoadingProtocol,
         networkManager: NetworkManagerProtocol) {
        self.view = view
        self.router = router
        self.imageLoader = imageLoader
        self.networkManager = networkManager
    }
    
    func showDetailedInfo() {
        router.next()
    }
    
    func fetchImages(isNewList: Bool) {
        if isNewList {
            resetKingfisher()
        }
        
        networkManager.getPhotos(count: 20) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponse(weakSelf: self,
                                     photos: response,
                                     isNewList: isNewList)
                
            case .failure(let error):
                self?.sendError(weakSelf: self, error: error)
            }
        }
    }
    
    func downloadImage(for indexPath: IndexPath) {
        guard let urlString = photos?[indexPath.row].urlString else {
            sendError(weakSelf: self, error: .missingURL)
            return
        }
        
        imageLoader?.downloadData(by: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.view?.setImage(image, for: indexPath)
                
            case .failure(let error):
                self?.sendError(weakSelf: self, error: error)
            }
        }
    }
    
    func searchFor(_ text: String) {
        networkManager.searchPhotos(keyword: text) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponse(weakSelf: self,
                                     photos: response,
                                     isNewList: true)
                
            case .failure(let error):
                self?.sendError(weakSelf: self, error: error)
            }
        }
    }
}

//MARK: - Private Functions
extension RandomPresenter {
    private func formattedResponse(_ response: [BasicPhotoResponse]) -> [PhotoModel] {
        var photos = [PhotoModel]()
        
        for item in response {
            let photo = PhotoModel(id: item.id,
                                   urlString: item.urls.small)
            photos.append(photo)
        }
        
        return photos
    }
    
    private func handleResponse(weakSelf: RandomPresenter?,
                                photos: [BasicPhotoResponse],
                                isNewList: Bool) {
        if let photos = weakSelf?.formattedResponse(photos) {
            if isNewList {
                weakSelf?.photos = photos
            } else {
                weakSelf?.photos?.append(contentsOf: photos)
            }
        }
        DispatchQueue.main.async {
            if let count = weakSelf?.photos?.count {
                weakSelf?.view?.updateCollection(count: count)
            }
        }
    }
    
    private func sendError(weakSelf: RandomPresenter?, error: NetworkError) {
        DispatchQueue.main.async {
            weakSelf?.view?.showAlert(title: "An error caused",
                                     message: error.rawValue)
        }
    }
    
    private func resetKingfisher() {
        KingfisherManager.shared.downloader.cancelAll()
        
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}
