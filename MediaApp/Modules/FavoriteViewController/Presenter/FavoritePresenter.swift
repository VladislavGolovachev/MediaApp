//
//  FavoritePresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import Foundation

//MARK: FavoriteViewProtocol
protocol FavoriteViewProtocol: AnyObject {
    
}

//MARK: - FavoriteViewPresenterProtocol
protocol FavoriteViewPresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol, router: RouterProtocol)
}

//MARK: - FavoritePresenter
final class FavoritePresenter: FavoriteViewPresenterProtocol {
    weak var view: FavoriteViewProtocol?
    var router: RouterProtocol
//    var dataManager: DataManagerProtocol
    
    init(view: FavoriteViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
