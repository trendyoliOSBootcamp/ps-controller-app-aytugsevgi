//
//  ControllerCollectionViewCell.swift
//  ps5Controller
//
//  Created by aytug on 1.05.2021.
//

import UIKit

class ControllerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ControllerCollectionViewCell"
    static func nib() -> UINib {
        UINib(nibName: "ControllerCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak private var cellButton: UIButton!
    
    func configure(with product: Product) {
        cellButton.setImage(product.image, for: .normal)
    }
}

