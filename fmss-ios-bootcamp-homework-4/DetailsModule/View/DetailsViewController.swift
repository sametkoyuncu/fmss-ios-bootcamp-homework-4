//
//  DetailsViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    static let storyboardID = "DetailsVC"
    
    var selectedId: String?
    
    var detailsType: DetailsTypeEnum?
    
    var detailsViewModel: DetailsViewModelMethodsProtocol?
    
    // outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    // MARK: - Section Heading
    override func viewDidDisappear(_ animated: Bool) {
        detailsViewModel?.viewDelegate = nil
        detailsViewModel = nil
    }
    
    func setup() {
        
        if let detailsType = detailsType {
            titleLabel.text = detailsType.rawValue
        }
        
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 35
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch detailsType {
        case .hotels:
            detailsViewModel = HotelDetailsViewModel()
        case .flights:
            detailsViewModel = FlightDetailsViewModel()
        case .articles:
            detailsViewModel = ArticleDetailsViewModel()
        case .none:
            fatalError("Details Type Not Found! (from viewWillAppear)")
        }
        
        detailsViewModel?.viewDelegate = self
        
        if let selectedId = selectedId {
            detailsViewModel?.didViewLoad(selectedId)
        }
        
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        let item = detailsViewModel!.getModel()
        
        let newItem: BookmarkItem = .init(idForSearch: item.id!,
                                          title: item.cellTitle!,
                                          description: item.cellTitle!,
                                          image: item.image!,
                                          type: detailsType!)
        
        detailsViewModel?.didSaveButtonPressed(newItem: newItem)
    }
}

extension DetailsViewController: DetailsViewModelViewDelegateProtocol {
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            let item = detailsViewModel!.getModel()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                self.coverImage.image = UIImage(named: item.image ?? "noImage")
                self.titleLabel.text = item.cellTitle
                self.descriptionLabel.text = item.desc
                self.categoryLabel.text = item.category
            }
        } else {
            // TODO:
        }
    }
}


