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
    
    private let scrollView = UIScrollView()
    private let stackView = {
        let stackView = UIStackView()
        
        stackView.backgroundColor = GlobalConstants.Color.background
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = LocalConstants.spacing
        
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = GlobalConstants.Color.background
        imageView.contentMode = .redraw
        imageView.clipsToBounds = false
        
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
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = LocalConstants.Font.location
        label.textColor = GlobalConstants.Color.secondaryText
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = LocalConstants.Font.date
        label.textColor = GlobalConstants.Color.secondaryText
        
        return label
    }()
    
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GlobalConstants.Color.background
        tabBarController?.tabBar.isHidden = true
        
//        imageView.image = UIImage(named: "als")
        imageView.image = UIImage(named: "test2")
//        imageView.image = UIImage(named: "test3")
        authorLabel.text = "Author: ArthuaBill"
        locationLabel.text = "Canada, Mexnico (12.02.2019)"
//        dateLabel.text = "12.02.2019"
        downloadsAmountLabel.text = "11230914 downloads"
        
//        imageView.image?.scale = 0.1
        imageView.contentScaleFactor = 0.2
        
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        getImage()
    }
    
    func getImage() {
        guard let image = imageView.image else { return }
        
        let size = image.size
        let multiplier: CGFloat = view.bounds.width / size.width
        let newSize = CGSize(width: size.width * multiplier, height: size.height * multiplier)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        imageView.image = newImage
    }
}

//MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    
}

//MARK: Private Functions
extension DetailViewController {
    private func addSubviews() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(downloadsAmountLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(dateLabel)
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        var imageAspectRatioConstraint: NSLayoutConstraint?
//        if let size = imageView.image?.size, size.height < size.width {
            imageAspectRatioConstraint = imageView.heightAnchor.constraint(
                lessThanOrEqualTo: imageView.widthAnchor,
                multiplier: imageView.image!.size.height / imageView.image!.size.width
            )
//        }
        imageAspectRatioConstraint?.isActive = true
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
//                                               constant: LocalConstants.padding),
//            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
//                                                constant: -LocalConstants.padding)
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
