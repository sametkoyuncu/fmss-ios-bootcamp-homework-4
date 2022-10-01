//
//  HomeCollectionViewCell.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var coverImage: UIImageView!
    static let identifier = "HomeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }

}
