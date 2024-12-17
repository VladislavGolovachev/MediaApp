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
    
    private var cellSize: CGSize = .zero
    private var elementsCount = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self,
                          action: #selector(refreshAction(_:)),
                          for: .valueChanged)
        
        return refresh
    }()
    
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
        
        collectionView.refreshControl = refreshControl
        
        collectionView.register(RandomCollectionViewCell.self,
                                forCellWithReuseIdentifier: RandomCollectionViewCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchImages(isNewList: true, keyword: nil)
        
        view.backgroundColor = GlobalConstants.Color.background
        customizeBars()
        
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        let spaceWidth = CGFloat(LocalConstants.itemsPerRow - 1) * LocalConstants.spacing
        + LocalConstants.padding * 2.0
        
        let cellWidth = Int((view.bounds.width - spaceWidth) / CGFloat(LocalConstants.itemsPerRow))
        
        cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - Actions
extension RandomViewController {
    @objc func refreshAction(_ sender: UIRefreshControl) {
        elementsCount = 0
        presenter?.fetchImages(isNewList: true, keyword: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension RandomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return elementsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RandomCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath)
        as? RandomCollectionViewCell ?? RandomCollectionViewCell()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.presenter?.downloadImage(for: indexPath)
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension RandomViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter?.showDetailedInfo(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay
                        cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == elementsCount - 1 {
            presenter?.fetchImages(isNewList: false, keyword: nil)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension RandomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

//MARK: - UISearchBarDelegate
extension RandomViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        presenter?.fetchImages(isNewList: true, keyword: text)
    }
}

//MARK: - RandomViewProtocol
extension RandomViewController: RandomViewProtocol {
    func updateCollection(count: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
        
        elementsCount = count
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func setImage(_ image: UIImage, for indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? RandomCollectionViewCell
        cell?.setImage(image)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
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
        tabBarController?.tabBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = GlobalConstants.Color.background
        navigationController?.navigationBar.backgroundColor = GlobalConstants.Color.background
        
        navigationItem.title = LocalConstants.title
        navigationController?.navigationBar.titleTextAttributes = [
            .font: GlobalConstants.Font.title,
            .foregroundColor: GlobalConstants.Color.title
        ]
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.overrideUserInterfaceStyle = .light
        
        navigationItem.searchController = searchController
    }
}

//MARK: - Local constants
extension RandomViewController {
    private enum LocalConstants {
        static let title            = "Collection Pictures"
        static let itemsPerRow      = 2
        static let spacing: CGFloat = 2
        static let padding: CGFloat = 4
    }
}
