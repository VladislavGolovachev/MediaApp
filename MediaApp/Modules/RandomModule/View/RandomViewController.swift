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
    
    var cellSize: CGSize = .zero
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = LocalConstants.spacing
        layout.minimumLineSpacing = LocalConstants.spacing
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        
        collectionView.backgroundColor = GlobalConstants.Color.background
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(RandomCollectionViewCell.self,
                                forCellWithReuseIdentifier: RandomCollectionViewCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GlobalConstants.Color.background
        customizeBars()
        
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        let spaceWidth = CGFloat(LocalConstants.itemsPerRow - 1) * LocalConstants.spacing + LocalConstants.padding * 2.0
        let cellWidth = Int((view.bounds.width - spaceWidth) / CGFloat(LocalConstants.itemsPerRow))
        
        cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
}

//MARK: - UICollectionViewDataSource
extension RandomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RandomCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath)
        as? RandomCollectionViewCell ?? RandomCollectionViewCell()
        
        cell.backgroundColor = GlobalConstants.Color.background
        cell.setImage(UIImage(systemName: "bell")!)
        
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension RandomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

//MARK: - RandomViewProtocol
extension RandomViewController: RandomViewProtocol {
    
}

//MARK: - Private Functions
extension RandomViewController {
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                    constant: LocalConstants.padding),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                     constant: -LocalConstants.padding)
        ])
    }
    
    private func customizeBars() {
        tabBarController?.tabBar.barTintColor = GlobalConstants.Color.background
        
        navigationController?.navigationBar.barTintColor = GlobalConstants.Color.background
        navigationController?.navigationBar.backgroundColor = GlobalConstants.Color.background
        
        navigationItem.title = LocalConstants.title
        navigationController?.navigationBar.titleTextAttributes = [
            .font: GlobalConstants.Font.title,
            .foregroundColor: GlobalConstants.Color.title
        ]
    }
}

//MARK: - Local constants
extension RandomViewController {
    private enum LocalConstants {
        static let title            = "Collection Pictures"
        static let itemsPerRow      = 3
        static let spacing: CGFloat = 2
        static let padding: CGFloat = 4
    }
}
