//
//  Assembly.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

protocol AssemblyProtocol {
    func createRandomModule(router: RouterProtocol) -> UIViewController
    func createFavoriteModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol) -> UIViewController
}

struct Assembly: AssemblyProtocol {
    func createRandomModule(router: RouterProtocol) -> UIViewController {
        let vc = RandomViewController()
        let presenter = RandomPresenter(view: vc, router: router)
        
        vc.presenter = presenter
        
        return vc
    }
    
    func createFavoriteModule(router: RouterProtocol) -> UIViewController {
        let vc = FavoriteViewController()
        let presenter = FavoritePresenter(view: vc, router: router)
        
        vc.presenter = presenter
        
        return vc
    }
    
    func createDetailModule(router: RouterProtocol) -> UIViewController {
        let vc = DetailViewController()
        let presenter = DetailPresenter(view: vc, router: router)
        
        vc.presenter = presenter
        
        return vc
    }
}
