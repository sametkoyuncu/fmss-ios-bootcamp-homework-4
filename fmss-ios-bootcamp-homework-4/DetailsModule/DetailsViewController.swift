//
//  DetailsViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    static let storyboardID = "DetailsVC"
    
    var detailsType: DetailsTypeEnum?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailsType = detailsType {
            titleLabel.text = detailsType.rawValue
        }
        
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 35
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        navigationController?.navigationBar.isHidden = true

    }
    @IBAction func bavkButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
    }
}
