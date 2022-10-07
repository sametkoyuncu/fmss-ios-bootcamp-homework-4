//
//  HomeCollectionViewCell.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"
    // for adding or removing bookmark
    var handleClick: (()->())?
    
    // outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkIcon: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        // Configure the cell
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
    
    // add or remove bookmark button
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        handleClick?()
    }
    
}
