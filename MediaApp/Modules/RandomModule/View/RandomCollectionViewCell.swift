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
    
    private let imageView = UIImageView()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        setupConstraints()
        
        imageView.contentMode = LocalConstants.contentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = LocalConstants.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - CollectionViewCell's Functions
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
        static let contentMode: UIImageView.ContentMode = .scaleAspectFill
        static let cornerRadius: CGFloat = 4
    }
}
