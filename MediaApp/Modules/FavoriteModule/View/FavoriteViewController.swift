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
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GlobalConstants.Color.background
        customizeBars()
        
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
        return 20
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier,
                                                 for: indexPath)
        as? FavoriteTableViewCell ?? FavoriteTableViewCell()
        
        cell.selectionStyle = .none
        cell.setImage(UIImage(named: "als")!)
        cell.setAuthor("Author Bill")
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetailedInfo()
    }
}

//MARK: - FavoriteViewProtocol
extension FavoriteViewController: FavoriteViewProtocol {
    
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
