//
//  DetailPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, router: RouterProtocol)
}

final class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: RouterProtocol
    
    init(view: DetailViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
