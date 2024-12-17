//
//  Router.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

//MARK: RouterProtocol
protocol RouterProtocol: AnyObject {
    func initiateRootViewController() -> UIViewController
    func next()
    func pop()
}

//MARK: - Router
final class Router: RouterProtocol {
    var rootViewController: UITabBarController?
    var assembly: AssemblyProtocol
    
    init(assembly: AssemblyProtocol) {
        self.assembly = assembly
    }
    
    func initiateRootViewController() -> UIViewController {
        let tabController = createTabBarController()
        rootViewController = tabController
        
        return tabController as UIViewController
    }
    
    func next() {
        guard let navVC =
        rootViewController?.selectedViewController as? UINavigationController else { return }

        let vc = assembly.createDetailModule(router: self)
        
        navVC.pushViewController(vc, animated: true)
    }
    
    func pop() {
        guard let navVC =
        rootViewController?.selectedViewController as? UINavigationController else { return }
        
        navVC.popViewController(animated: true)
    }
}

//MARK: - Private Functions
extension Router {
    private func createTabBarController() -> UITabBarController {
        let randomVC = assembly.createRandomModule(router: self)
        let favVC = assembly.createFavoriteModule(router: self)
        
        let randomNavVC = UINavigationController(rootViewController: randomVC)
        let favNavVC = UINavigationController(rootViewController: favVC)
        
        let tabController = UITabBarController(tabs: [
            UITab(title: "Pictures",
                  image: UIImage(systemName: "photo"),
                  identifier: String(),
                  viewControllerProvider: { _ in
                      randomNavVC
                  }),
            UITab(title: "Favorites",
                  image: UIImage(systemName: "heart"),
                  identifier: String(),
                  viewControllerProvider: { _ in
                      favNavVC
                  }),
        ])
        
        return tabController
    }
}
