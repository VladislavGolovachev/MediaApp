//
//  RandomPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import Foundation

protocol RandomViewProtocol: AnyObject {
    
}

protocol RandomViewPresenterProtocol: AnyObject {
    init(view: RandomViewProtocol, router: RouterProtocol)
}

final class RandomPresenter: RandomViewPresenterProtocol {
    weak var view: RandomViewProtocol?
    var router: RouterProtocol
//    var networkService: NetworkService?
    
    init(view: RandomViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
