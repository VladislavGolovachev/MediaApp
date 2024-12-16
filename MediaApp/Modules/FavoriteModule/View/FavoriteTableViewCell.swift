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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awake from nib")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("init style reuseidentifier")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}
