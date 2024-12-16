//
//  GlobalConstants.swift
//  MediaApp
//
//  Created by Владислав Головачев on 16.12.2024.
//

import UIKit

enum GlobalConstants {
    enum Color {
        static let background: UIColor  = .white
        static let title: UIColor       = .black
    }
    enum Font {
        static let title: UIFont    = .systemFont(ofSize: 18,
                                                  weight: .semibold)
        //FIXME: Change the common text's font
        static let common: UIFont   = .systemFont(ofSize: 14)
    }
}
