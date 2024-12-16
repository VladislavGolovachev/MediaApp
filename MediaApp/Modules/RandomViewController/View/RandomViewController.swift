//
//  ViewController.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class RandomViewController: UIViewController {
    var presenter: RandomViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

extension RandomViewController: RandomViewProtocol {
    
}
