//
//  FavoritePresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import Foundation

protocol FavoriteViewProtocol: AnyObject {
    
}

protocol FavoriteViewPresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol, router: RouterProtocol)
}

final class FavoritePresenter: FavoriteViewPresenterProtocol {
    weak var view: FavoriteViewProtocol?
    var router: RouterProtocol
//    var dataManager: DataManagerProtocol
    
    init(view: FavoriteViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
