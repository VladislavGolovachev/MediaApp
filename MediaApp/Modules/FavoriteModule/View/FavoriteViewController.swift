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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = GlobalConstants.Color.background
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = LocalConstants.rowHeight
        
        tableView.register(FavoriteTableViewCell.self,
                           forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private var elementsCount = 0
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchPhotos()
        
        view.backgroundColor = GlobalConstants.Color.background
        customizeBars()
        
        tabBarController?.delegate = self
        
        view.addSubview(tableView)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return elementsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier,
                                                 for: indexPath)
        as? FavoriteTableViewCell ?? FavoriteTableViewCell()
        
        cell.selectionStyle = .none
        if let image = presenter?.image(for: indexPath) {
            cell.setImage(image)
        }
        if let author = presenter?.author(for: indexPath) {
            cell.setAuthor(author)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetailedInfo(for: indexPath)
    }
}

//MARK: - UITabBarControllerDelegate
extension FavoriteViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelectTab selectedTab: UITab,
                          previousTab: UITab?) {
        if selectedTab.identifier == GlobalConstants.TabIdentifier.second {
            presenter?.fetchPhotos()
        }
    }
}

//MARK: - FavoriteViewProtocol
extension FavoriteViewController: FavoriteViewProtocol {
    func updateTable(count: Int) {
        elementsCount = count
        tableView.reloadData()
    }
    
    func setCellInfo(_ photoModel: FavoritePhotoModel, for indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
        as? FavoriteTableViewCell else {
            return
        }
        
        cell.setImage(photoModel.image)
        cell.setAuthor(photoModel.author)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

//MARK: - Private Functions
extension FavoriteViewController {
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
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
extension FavoriteViewController {
    private enum LocalConstants {
        static let title = "Favorite Pictures"
        static let rowHeight: CGFloat = 100
    }
}
