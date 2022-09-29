//
//  DetailsTableViewCell.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    static let identifier = "ListTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
