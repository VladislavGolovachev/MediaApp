//
//  FavoriteTableViewCell.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    //MARK: - Variables
    static let reuseIdentifier = "FavoritePictureIdentifier"
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = GlobalConstants.Color.cell
        view.layer.cornerRadius = LocalConstants.cornerRadius
        
        return view
    }()
    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = GlobalConstants.Color.background
        
        imageView.layer.cornerRadius = LocalConstants.cornerRadius
        
        return imageView
    }()
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = LocalConstants.font
        
        return label
    }()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = GlobalConstants.Color.background
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - UITableViewCell's Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView.image = nil
        authorNameLabel.text = String()
    }
}

//MARK: - Public Functions
extension FavoriteTableViewCell {
    func setImage(_ image: UIImage) {
        pictureImageView.image = image
    }
    
    func setAuthor(_ text: String) {
        authorNameLabel.text = text
    }
}

//MARK: - Private Functions
extension FavoriteTableViewCell {
    private func addSubviews() {
        backView.addSubview(pictureImageView)
        backView.addSubview(authorNameLabel)
        contentView.addSubview(backView)
    }
    
    private func setupConstraints() {
        backView.translatesAutoresizingMaskIntoConstraints = false
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalPadding = LocalConstants.Padding.cellVertical / 2.0
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: verticalPadding),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -verticalPadding),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: LocalConstants.Padding.cellHorizontal),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -LocalConstants.Padding.cellHorizontal),
            
            pictureImageView.topAnchor.constraint(equalTo: backView.topAnchor,
                                                  constant: LocalConstants.Padding.content),
            pictureImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor,
                                                  constant: -LocalConstants.Padding.content),
            pictureImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor,
                                                  constant: LocalConstants.Padding.content),
            pictureImageView.widthAnchor.constraint(equalTo: pictureImageView.heightAnchor,
                                                    multiplier: 1),
            
            authorNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: pictureImageView.trailingAnchor),
            authorNameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor,
                                                      constant: -LocalConstants.Padding.content),
            authorNameLabel.centerYAnchor.constraint(equalTo: pictureImageView.centerYAnchor)
        ])
    }
}

//MARK: - Local Constants
extension FavoriteTableViewCell {
    private enum LocalConstants {
        static let font: UIFont = .systemFont(ofSize: 18,
                                              weight: .medium)
        static let cornerRadius: CGFloat = 16
        
        enum Padding {
            static let content: CGFloat         = 8
            static let cellHorizontal: CGFloat  = 8
            static let cellVertical: CGFloat    = 4
        }
    }
}
