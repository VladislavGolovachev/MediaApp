//
//  Assembly.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

//MARK: AssemblyProtocol
protocol AssemblyProtocol {
    func createRandomModule(router: RouterProtocol) -> UIViewController
    func createFavoriteModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol,
                            id: String) -> UIViewController
}

//MARK: - Assembly
struct Assembly: AssemblyProtocol {
    func createRandomModule(router: RouterProtocol) -> UIViewController {
        let vc = RandomViewController()
        let networkManager = NetworkManager()
        let imageLoader = ImageLoader()
        
        let presenter = RandomPresenter(view: vc,
                                        router: router,
                                        imageLoader: imageLoader,
                                        networkManager: networkManager)
        
        vc.presenter = presenter
        
        return vc
    }
    
    func createFavoriteModule(router: RouterProtocol) -> UIViewController {
        let vc = FavoriteViewController()
        let presenter = FavoritePresenter(view: vc, router: router)
        
        vc.presenter = presenter
        
        return vc
    }
    
    func createDetailModule(router: RouterProtocol,
                            id: String) -> UIViewController {
        let vc = DetailViewController()
        let networkManager = NetworkManager()
        let dataManager = DataManager()
        let imageLoader = ImageLoader()
        
        let presenter = DetailPresenter(view: vc,
                                        router: router,
                                        dataManager: dataManager,
                                        networkManager: networkManager,
                                        imageLoader: imageLoader,
                                        id: id)
        
        vc.presenter = presenter
        
        return vc
    }
}
