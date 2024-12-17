//
//  RandomPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

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
        networkManager.getPhotos(count: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let photos = self?.formattedResponse(response) {
                    if isNewList {
                        self?.photos = photos
                    } else {
                        self?.photos?.append(contentsOf: photos)
                    }
                }
                DispatchQueue.main.async {
                    if let count = self?.photos?.count {
                        self?.view?.updateCollection(count: count)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(title: "An error caused",
                                          message: error.rawValue)
                }
            }
        }
    }
    
    func downloadImage(for indexPath: IndexPath) {
        guard let urlString = photos?[indexPath.row].urlString else {
            DispatchQueue.main.async {
                self.view?.showAlert(title: "An error caused",
                                     message: NetworkError.unknown.rawValue)
            }
            return
        }
        
        imageLoader?.downloadData(by: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.view?.setImage(image, for: indexPath)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(title: "An error caused",
                                          message: error.rawValue)
                }
            }
        }
    }
}

//MARK: - Private Functions
extension RandomPresenter {
    private func formattedResponse(_ response: [RandomResponse]) -> [PhotoModel] {
        var photos = [PhotoModel]()
        
        for item in response {
            let photo = PhotoModel(id: item.id,
                                   urlString: item.urls.small)
            photos.append(photo)
        }
        
        return photos
    }
}
