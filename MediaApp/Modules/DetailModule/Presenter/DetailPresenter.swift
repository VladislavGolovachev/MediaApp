//
//  DetailPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

//MARK: DetailViewProtocol
protocol DetailViewProtocol: AnyObject {
    func updateScreen(with: PhotoInfo)
    
    func showAlert(title: String, message: String)
}

//MARK: - DetailViewPresenterProtocol
protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol,
         router: RouterProtocol,
         dataManager: DataManager,
         networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoadingProtocol,
         isFavorite: Bool,
         id: String)
    
    func updateScreen()
    func showPreviousScreen()
}

//MARK: - DetailPresenter
final class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: RouterProtocol
    var dataManager: DataManager?
    var networkManager: NetworkManagerProtocol
    var imageLoader: ImageLoadingProtocol?
    
    private var isFavorite: Bool
    private var photoID: String
    
    // MARK: - Initializers
    init(view: DetailViewProtocol,
         router: RouterProtocol,
         dataManager: DataManager,
         networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoadingProtocol,
         isFavorite: Bool,
         id: String) {
        self.view = view
        self.router = router
        self.dataManager = dataManager
        self.networkManager = networkManager
        self.imageLoader = imageLoader
        self.isFavorite = isFavorite
        self.photoID = id
    }
    
    // MARK: - Functions
    func updateScreen() {
        if isFavorite {
            do {
                guard let photos = try dataManager?.fetch(amongObjectsWithKeyedValues: [
                    PhotoKeys.id.rawValue: photoID
                ]) else {
                    sendError(weakSelf: self, message: StorageError.unknown.rawValue)
                    return
                }
//                prepareDataToShow(photos[0])
                
            } catch(let error) {
                if let error = error as? StorageError {
                    sendError(weakSelf: self, message: error.rawValue)
                } else {
                    sendError(weakSelf: self, message: StorageError.unknown.rawValue)
                }
            }
        } else {
            networkManager.getPhotoInfo(id: photoID) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.prepareResponseToShow(response)
                    
                case .failure(let error):
                    self?.sendError(weakSelf: self, message: error.rawValue)
                }
            }
        }
    }
    
    func showPreviousScreen() {
        router.pop()
    }
}

//MARK: Private Functions
extension DetailPresenter {
    private func sendError(weakSelf: DetailPresenter?, message: String) {
        DispatchQueue.main.async {
            weakSelf?.view?.showAlert(title: "An error caused",
                                      message: message)
        }
    }
    
//    private func prepareDataToShow(_ entity: PhotoEntity) {
//        if let imageData = entity.imageData {
//            if let image = UIImage(data: imageData) {
//                DispatchQueue.main.async {
//                    self.view?.updateImage(image)
//                }
//            } else {
//                sendError(weakSelf: self, message: StorageError.fetchingFailed.rawValue)
//            }
//        }
//        DispatchQueue.main.async {
//            self.view?.updateAuthor(entity.author ?? "Author not stated")
//        }
//        DispatchQueue.main.async {
//            self.view?.updateDownloads(String(entity.downloads))
//        }
//        var locationDate = ""
//        if let location = entity.location {
//            locationDate = location
//        }
//        if let creationDate = entity.creationDate {
//            let date = formattedDate(creationDate)
//            locationDate += "(\(date))"
//        }
//        DispatchQueue.main.async {
//            self.view?.updateLocationDate(locationDate)
//        }
//    }
    
    private func prepareResponseToShow(_ response: PhotoResponse) {
        imageLoader?.downloadData(by: response.urls.small) { [weak self] result in
            switch result {
            case .success(let image):
                let photoInfo = PhotoInfo(image: image,
                                          author: response.user.name,
                                          downloads: response.downloads,
                                          location: response.user.location,
                                          date: self?.formattedDate(response.creationDate))
                DispatchQueue.main.async {
                    self?.view?.updateScreen(with: photoInfo)
                }
                
            case .failure(let error):
                self?.sendError(weakSelf: self, message: error.rawValue)
            }
        }
    }
    
    private func formattedDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let string = dateFormatter.string(from: date)
        
        return string
    }
}
