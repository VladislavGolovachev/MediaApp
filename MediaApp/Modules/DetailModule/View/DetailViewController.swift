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
    
    let scrollView = UIScrollView()
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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let downloadsAmountLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    
    //MARK: - ViewController's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GlobalConstants.Color.background
        
//        imageView.image = UIImage(named: "als")
//        imageView.image = UIImage(named: "test2")
        imageView.image = UIImage(named: "test3")
        authorLabel.text = "Author is Arthuasmfsdmklfmaskl;fmlasdmdl;kadmslk;cvasdr"
        locationLabel.text = "Canada, mex\nico"
        dateLabel.text = "12.2.\n3."
        downloadsAmountLabel.text = "11230914 downloads"
        
        addSubviews()
        setupConstraints()
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
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(downloadsAmountLabel)
        
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var imageAspectRatioConstraint: NSLayoutConstraint?
        if let size = imageView.image?.size, size.height < size.width {
            imageAspectRatioConstraint = imageView.heightAnchor.constraint(
                lessThanOrEqualTo: imageView.widthAnchor,
                multiplier: imageView.image!.size.height / imageView.image!.size.width
            )
        } else {
            imageAspectRatioConstraint = imageView.heightAnchor.constraint(
                lessThanOrEqualTo: view.heightAnchor,
                multiplier: 0.7
            )
        }
        imageAspectRatioConstraint?.isActive = true
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                               constant: LocalConstants.padding),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                constant: -LocalConstants.padding)
        ])
    }
}

//MARK: - Local Constants
extension DetailViewController {
    private enum LocalConstants {
        static let spacing: CGFloat = 15
        static let padding: CGFloat = 4
    }
}
