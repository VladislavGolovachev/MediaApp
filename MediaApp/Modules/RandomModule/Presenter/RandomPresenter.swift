//
//  RandomPresenter.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import Foundation

//MARK: RandomViewProtocol
protocol RandomViewProtocol: AnyObject {
    
}

//MARK: - RandomViewPresenterProtocol
protocol RandomViewPresenterProtocol: AnyObject {
    init(view: RandomViewProtocol, router: RouterProtocol)
    func showDetailedInfo()
}

//MARK: - RandomPresenter
final class RandomPresenter: RandomViewPresenterProtocol {
    //MARK: -Variables
    weak var view: RandomViewProtocol?
    var router: RouterProtocol
//    var networkService: NetworkService?
    
    //MARK: RandomViewPresenterProtocol's Implementation
    init(view: RandomViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showDetailedInfo() {
        router.next()
    }
}
