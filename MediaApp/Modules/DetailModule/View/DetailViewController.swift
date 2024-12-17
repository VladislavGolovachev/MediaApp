//
//  DetailViewController.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    //MARK: - Variables
    var presenter: DetailViewPresenterProtocol?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        
        stackView.backgroundColor = GlobalConstants.Color.background
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = LocalConstants.spacing
        stackView.alpha = 0
        
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = GlobalConstants.Color.background
        imageView.alpha = 0
        
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = LocalConstants.Font.author
        
        return label
    }()
    
    private let downloadsAmountLabel: UILabel = {
        let label = UILabel()
        label.font = LocalConstants.Font.downloads
        
        return label
    }()
    
    private let locationDateLabel: UILabel = {
        let label = UILabel()
        label.font = LocalConstants.Font.location
        label.textColor = GlobalConstants.Color.secondaryText
        
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
        
        return activityIndicator
    }()
    
    private var isFavorite = false
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.startAnimating()
        
        presenter?.updateScreen()
        
        view.backgroundColor = GlobalConstants.Color.background
        tabBarController?.tabBar.isHidden = true
        
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addToFavsAction(_:)))
        navigationItem.rightBarButtonItem = button
        
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        //FIXME: Change imageView.image to the presenter.image like
        guard let image = imageView.image else { return }
        
        imageView.image = image.resizedTo(constant: view.bounds.width,
                                          by: .width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view.bounds.height >= scrollView.contentSize.height {
            return
        }
        
        let offsetY = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
        let bottomOffset = CGPoint(x: 0, y: offsetY)
        
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
}

//MARK: - Actions
extension DetailViewController {
    @objc func addToFavsAction(_ sender: UIBarButtonItem) {
        if isFavorite {
            sender.image = UIImage(systemName: "heart")
        } else {
            sender.image = UIImage(systemName: "heart.fill")
        }
        
        isFavorite.toggle()
    }
}

//MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func updateScreen(with photoInfo: PhotoInfo) {
        activityIndicatorView.stopAnimating()
        
        imageView.image = photoInfo.image
        authorLabel.text = photoInfo.author
        downloadsAmountLabel.text = photoInfo.downloads
        locationDateLabel.text = photoInfo.locationDate
        
        UIView.animate(withDuration: 0.8) {
            self.imageView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.stackView.alpha = 1
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            self?.presenter?.showPreviousScreen()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

//MARK: Private Functions
extension DetailViewController {
    private func addSubviews() {
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(downloadsAmountLabel)
        stackView.addArrangedSubview(locationDateLabel)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        view.addSubview(activityIndicatorView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                           constant: LocalConstants.spacing),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                               constant: LocalConstants.padding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                constant: LocalConstants.padding)
        ])
    }
}

//MARK: - Local Constants
extension DetailViewController {
    private enum LocalConstants {
        static let spacing: CGFloat = 10
        static let padding: CGFloat = 6
        
        enum Font {
            static let author: UIFont       = .systemFont(ofSize: 18,
                                                          weight: .medium)
            static let downloads: UIFont    = .systemFont(ofSize: 18)
            static let location: UIFont     = .systemFont(ofSize: 16)
            static let date: UIFont         = .systemFont(ofSize: 16)
        }
    }
}
