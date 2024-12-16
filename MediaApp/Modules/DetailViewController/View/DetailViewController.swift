//
//  DetailViewController.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    var presenter: DetailViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

extension DetailViewController: DetailViewProtocol {
    
}
