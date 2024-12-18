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
    
    func setPictureFavorite()
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
    
    private let queue = DispatchQueue(label: "queue-presenter-vladislavgolovachev",
                                      qos: .utility,
                                      attributes: .concurrent)
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
        queue.async {
            if let photoEntity = self.isAbleToFetchPhotoFromCoreData(id: self.photoID) {
                DispatchQueue.main.async {
                    self.view?.setPictureFavorite()
                }
                self.handleEntity(photoEntity)
            } else {
                self.networkManager.getPhotoInfo(id: self.photoID) { [weak self] result in
                    switch result {
                    case .success(let response):
                        self?.handleResponse(weakSelf: self, response)
                        
                    case .failure(let error):
                        self?.sendError(weakSelf: self, message: error.rawValue)
                    }
                }
            }
        }
    }
    
    func addToFavorites() {
        guard let photoInfo else { return }
        
        queue.async {
            do {
                let keyedValues: [String: Any] = [
                    PhotoKeys.author.rawValue: photoInfo.author,
                    PhotoKeys.creationDate.rawValue: photoInfo.date,
                    PhotoKeys.imageData.rawValue: photoInfo.image.pngData(),
                    PhotoKeys.id.rawValue: self.photoID,
                    PhotoKeys.location.rawValue: photoInfo.location,
                    PhotoKeys.downloads.rawValue: photoInfo.downloads
                ]
                
                try self.dataManager?.persist(with: keyedValues)
            } catch {
                if let error = error as? StorageError {
                    self.sendError(weakSelf: self, message: error.rawValue)
                } else {
                    self.sendError(weakSelf: self,
                                   message: StorageError.unableToSaveData.rawValue)
                }
            }
        }
    }
    
    func removeFromFavorites() {
        queue.async {
            do {
                try self.dataManager?.delete(for: self.photoID)
            } catch {
                if let error = error as? StorageError {
                    self.sendError(weakSelf: self, message: error.rawValue)
                } else {
                    self.sendError(weakSelf: self,
                                   message: StorageError.unableToSaveData.rawValue)
                }
            }
        }
    }
    
    func showPreviousScreen() {
        DispatchQueue.main.async {
            self.router.pop()
        }
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
