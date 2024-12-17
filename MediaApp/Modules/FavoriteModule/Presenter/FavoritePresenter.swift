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
    func showDetailedInfo()
}

//MARK: - FavoritePresenter
final class FavoritePresenter: FavoriteViewPresenterProtocol {
    //MARK: - Variables
    weak var view: FavoriteViewProtocol?
    var router: RouterProtocol
//    var dataManager: DataManagerProtocol
    
    //MARK: - FavoriteViewPresenterProtocol
    init(view: FavoriteViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showDetailedInfo() {
        //FIXME: Change id
        fatalError()
        router.next(isFavorite: true, id: "asd")
    }
}
