//
//  FavoriteViewController.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class FavoriteViewController: UIViewController {
    var presenter: FavoriteViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}

extension FavoriteViewController: FavoriteViewProtocol {
    
}
