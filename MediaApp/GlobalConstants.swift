//
//  GlobalConstants.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

enum GlobalConstants {
    enum Color {
        static let background: UIColor      = .white
        static let title: UIColor           = .black
        static let secondaryText: UIColor   = .init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }
    enum Font {
        static let title: UIFont    = .systemFont(ofSize: 18,
                                                  weight: .semibold)
    }
}
