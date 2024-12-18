//
//  FavoritePresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

//MARK: FavoriteViewProtocol
protocol FavoriteViewProtocol: AnyObject {
    func showAlert(title: String, message: String)
    func updateTable(count: Int)
    func setCellInfo(_: FavoritePhotoModel, for: IndexPath)
}

//MARK: - FavoriteViewPresenterProtocol
protocol FavoriteViewPresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol,
         router: RouterProtocol,
         dataManager: DataManager)
    
    func fetchPhotos()
    func showDetailedInfo(for: IndexPath)
    func image(for indexPath: IndexPath) -> UIImage?
    func author(for indexPath: IndexPath) -> String?
}

//MARK: - FavoritePresenter
final class FavoritePresenter: FavoriteViewPresenterProtocol {
    //MARK: - Variables
    weak var view: FavoriteViewProtocol?
    var router: RouterProtocol
    var dataManager: DataManager?
    
    var photos = [FavoritePhotoModel]()
    private let queue = DispatchQueue(label: "queue-presenter-vladislavgolovachev",
                                      qos: .utility,
                                      attributes: .concurrent)
    
    //MARK: - Initializers
    init(view: FavoriteViewProtocol,
         router: RouterProtocol,
         dataManager: DataManager) {
        self.view = view
        self.router = router
        self.dataManager = dataManager
    }
    
    //MARK: - FavoriteViewPresenterProtocol Functions
    func fetchPhotos() {
        queue.async {
            do {
                guard let photos = try self.dataManager?.fetch() else {
                    self.sendError(title: LocalConstants.errorTitle,
                                   message: StorageError.fetchingFailed.rawValue)
                    return
                }
                for photo in photos {
                    if let image = UIImage(data: photo.imageData) {
                        let favPhoto = FavoritePhotoModel(image: image,
                                                          author: photo.author ?? "Not stated",
                                                          id: photo.id)
                        self.photos.append(favPhoto)
                    }
                }
                DispatchQueue.main.async {
                    self.view?.updateTable(count: photos.count)
                }
                
            } catch {
                if let error = error as? StorageError {
                    self.sendError(title: LocalConstants.errorTitle,
                                   message: error.rawValue)
                } else {
                    self.sendError(title: LocalConstants.errorTitle,
                                   message: StorageError.unableToSaveData.rawValue)
                }
            }
        }
    }
    
    func image(for indexPath: IndexPath) -> UIImage? {
        let row = indexPath.row
        return row < photos.count ? photos[row].image : nil
    }
    
    func author(for indexPath: IndexPath) -> String? {
        let row = indexPath.row
        return row < photos.count ? photos[row].author : nil
    }
    
    func showDetailedInfo(for indexPath: IndexPath) {
        router.next(id: self.photos[indexPath.row].id)
    }
}

//MARK: - Private Functions
extension FavoritePresenter {
    private func sendError(title: String, message: String) {
        DispatchQueue.main.async {
            self.view?.showAlert(title: title,
                                 message: message)
        }
    }
    
    private func handleEntity(_ entity: PhotoEntity) -> FavoritePhotoModel {
        guard let image = UIImage(data: entity.imageData) else {
            sendError(title: LocalConstants.errorTitle,
                      message: StorageError.missingObject.rawValue)
            return FavoritePhotoModel(image: UIImage(),
                                      author: entity.author ?? "Not stated",
                                      id: entity.id)
        }
        
        return FavoritePhotoModel(image: image,
                                  author: entity.author ?? "Not stated",
                                  id: entity.id)
    }
}


//MARK: Local Constants
extension FavoritePresenter {
    private enum LocalConstants {
        static let errorTitle = "An error caused"
    }
}
