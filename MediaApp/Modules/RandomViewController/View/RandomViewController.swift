//
//  ViewController.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class RandomViewController: UIViewController {
    //MARK: - Variables
    var presenter: RandomViewPresenterProtocol?
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        collectionView.dataSource = self
        //FIXME: Identifier
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "Identifier")
        
        return collectionView
    }()
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GlobalConstants.Color.background
        
        navigationItem.title = LocalConstants.title
        navigationController?.navigationBar.titleTextAttributes = [
            .font: GlobalConstants.Font.title
        ]
        
        addSubviews()
    }
}

//MARK: - UICollectionViewDataSource
extension RandomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//MARK: - RandomViewProtocol
extension RandomViewController: RandomViewProtocol {
    
}

//MARK: - Private Functions
extension RandomViewController {
    private func addSubviews() {
//        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        ])
    }
}

//MARK: - Local constants
extension RandomViewController {
    private enum LocalConstants {
        static let title = "Collection Pictures"
    }
}
