//
//  FavoriteViewController.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class FavoriteViewController: UIViewController {
    //MARK: - Variables
    var presenter: FavoriteViewPresenterProtocol?
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}

//MARK: - FavoriteViewProtocol
extension FavoriteViewController: FavoriteViewProtocol {
    
}
