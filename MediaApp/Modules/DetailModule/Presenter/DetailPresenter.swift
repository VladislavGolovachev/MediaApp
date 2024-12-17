//
//  DetailPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

//MARK: DetailViewProtocol
protocol DetailViewProtocol: AnyObject {
    func setImage(_: UIImage)
    func setAuthor(_: String)
    func setDownloads(_: String)
    func setLocationDate(_: String)
    func animate()
    
    func showAlert(title: String, message: String)
}

//MARK: - DetailViewPresenterProtocol
protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol,
         router: RouterProtocol,
         dataManager: DataManager,
         networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoadingProtocol,
         id: String)
    
    func updateScreen()
    func showPreviousScreen()
    func addToFavorites()
    func removeFromFavorites()
}

//MARK: - DetailPresenter
final class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: RouterProtocol
    var dataManager: DataManager?
    var networkManager: NetworkManagerProtocol
    var imageLoader: ImageLoadingProtocol?
    
    private var photoID: String
    private var photoInfo: PhotoInfo?
    
    // MARK: - Initializers
    init(view: DetailViewProtocol,
         router: RouterProtocol,
         dataManager: DataManager,
         networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoadingProtocol,
         id: String) {
        self.view = view
        self.router = router
        self.dataManager = dataManager
        self.networkManager = networkManager
        self.imageLoader = imageLoader
        self.photoID = id
    }
    
    // MARK: - Functions
    func updateScreen() {
        if let photoEntity = isAbleToFetchPhotoFromCoreData(id: photoID) {
            handleEntity(photoEntity)
        } else {
            networkManager.getPhotoInfo(id: photoID) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.handleResponse(weakSelf: self, response)
                    
                case .failure(let error):
                    self?.sendError(weakSelf: self, message: error.rawValue)
                }
            }
        }
    }
    enum PhotoKeys: String {
        case author         = "author"
        case creationDate   = "creationDate"
        case imageData      = "imageData"
        case id             = "id"
        case location       = "location"
    }
    func addToFavorites() {
        guard let photoInfo else { return }
        
//        do {
//            try dataManager?.persist(with: [
//                PhotoKeys.author: photoInfo.author,
//                PhotoKeys.creationDate: ,
//                PhotoKeys.imageData: photoInfo.image.data,
//                PhotoKeys.id: photoID,
//                PhotoKeys.location: photoInfo.locationDate,
//                PhotoKeys.downloads: photoInfo.downloads
//            ])
//        } catch {
//            if let error = error as? StorageError {
//                sendError(weakSelf: self, message: error.rawValue)
//            } else {
//                sendError(weakSelf: self,
//                          message: StorageError.unableToSaveData.rawValue)
//            }
//        }
    }
    
    func removeFromFavorites() {
        
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
    
    private func isAbleToFetchPhotoFromCoreData(id: String) -> PhotoEntity? {
        do {
            guard let photos = try dataManager?.fetch(for: id) else {
                sendError(weakSelf: self, message: StorageError.fetchingFailed.rawValue)
                return nil
            }
            
            return photos.count < 1 ? nil : photos[0]
            
        } catch {
            if let error = error as? StorageError {
                sendError(weakSelf: self, message: error.rawValue)
            } else {
                sendError(weakSelf: self, message: StorageError.unknown.rawValue)
            }
        }
        
        return nil
    }
    
    private func handleEntity(_ entity: PhotoEntity) {
        guard let image = UIImage(data: entity.imageData) else {
            sendError(weakSelf: self, message: StorageError.missingObject.rawValue)
            return
        }
        let photoInfo = PhotoInfo(image: image,
                                  author: entity.author,
                                  downloads: Int(entity.downloads),
                                  location: entity.location,
                                  date: entity.creationDate)
        self.photoInfo = photoInfo
        
        showPhotoInfo()
    }
    
    private func handleResponse(weakSelf: DetailPresenter?,
                                _ response: PhotoResponse) {
        weakSelf?.imageLoader?.downloadData(by: response.urls.small) { [weak self] result in
            switch result {
            case .success(let image):
                let photoInfo = PhotoInfo(image: image,
                                          author: response.user.name,
                                          downloads: response.downloads,
                                          location: response.user.location,
                                          date: self?.formattedDate(response.creationDate))
                self?.photoInfo = photoInfo
                self?.showPhotoInfo()
                
            case .failure(let error):
                self?.sendError(weakSelf: self, message: error.rawValue)
            }
        }
    }
    
    private func showPhotoInfo() {
        guard let photoInfo else { return }
        
        let location = photoInfo.location ?? "Location not stated"
        let date = formattedString(photoInfo.date) ?? "date not stated"
        
        DispatchQueue.main.async {
            self.view?.setImage(photoInfo.image)
            self.view?.setAuthor("Author: " + (photoInfo.author ?? "Author not stated"))
            self.view?.setDownloads("Downloads: " + String(photoInfo.downloads))
            self.view?.setLocationDate(location + " (\(date))")
            
            self.view?.animate()
        }
    }
    
    private func formattedDate(_ dateString: String?) -> Date? {
        guard let dateString else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)
        
        return date
    }
    
    private func formattedString(_ date: Date?) -> String? {
        guard let date else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let string = dateFormatter.string(from: date)
        
        return string
    }
}
