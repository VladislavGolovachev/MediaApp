//
//  RandomCollectionViewCell.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class RandomCollectionViewCell: UICollectionViewCell {
    //MARK: - Variables
    static let reuseIdentifier = "RandomPictureIdentifier"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = GlobalConstants.Color.background
        imageView.layer.cornerRadius = LocalConstants.cornerRadius
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - UICollectionViewCell's Functions
    override func prepareForReuse() {
        imageView.image = nil
    }
}

//MARK: - Public Functions
extension RandomCollectionViewCell {
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

//MARK: - Private Functions
extension RandomCollectionViewCell {
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

//MARK: Local Constants
extension RandomCollectionViewCell {
    private enum LocalConstants {
        static let cornerRadius: CGFloat = 7
    }
}
