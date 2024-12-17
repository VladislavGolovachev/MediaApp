//
//  DetailPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import Foundation

//MARK: DetailViewProtocol
protocol DetailViewProtocol: AnyObject {
    
}

//MARK: - DetailViewPresenterProtocol
protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol,
         router: RouterProtocol,
         dataManager: any CoreDataStorageManager,
         networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoadingProtocol)
}

//MARK: - DetailPresenter
final class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: RouterProtocol
    var dataManager: (any CoreDataStorageManager)?
    var networkManager: NetworkManagerProtocol
    var imageLoader: ImageLoadingProtocol?
    
    // MARK: - Initializers
    init(view: DetailViewProtocol,
         router: RouterProtocol,
         dataManager: any CoreDataStorageManager,
         networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoadingProtocol) {
        self.view = view
        self.router = router
        self.dataManager = dataManager
        self.networkManager = networkManager
        self.imageLoader = imageLoader
    }
    
    // MARK: - Functions
}
