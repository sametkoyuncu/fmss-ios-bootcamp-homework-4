//
//  DetailsViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit
import Kingfisher

enum ButtonState {
    case add
    case remove
}

class DetailsViewController: UIViewController {
    
    static let storyboardID = "DetailsVC"
    
    var detailsType: DetailsTypeEnum?
    
    var detailsViewModel: DetailsViewModelMethodsProtocol?
    
    var buttonState: ButtonState = .add
    
    // outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsViewModel?.didViewLoad()
        setup()
    }
    // MARK: - Section Heading
    override func viewDidDisappear(_ animated: Bool) {
        detailsViewModel?.viewDelegate = nil
        detailsViewModel = nil
    }
 
    func setup() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 35
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {        

        let item = detailsViewModel?.getModel()
        
        if let item = item {
            if buttonState == .add {
                let newItem: BookmarkItem = .init(idForSearch: item.id,
                                                  title: item.cellTitle,
                                                  description: item.desc,
                                                  image: item.image)
                detailsViewModel?.didSaveButtonPressed(newItem: newItem)
            } else {
                detailsViewModel?.removeFromFavoritesBy(id: item.id!)
            }
            
        }
        
    }
}

extension DetailsViewController: DetailsViewModelViewDelegateProtocol {
    func didItemRemoved(isSuccess: Bool) {
        if isSuccess {
            buttonState = .add
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.bookmarkButton.setImage(UIImage(named: "addBookmarkButton"), for: .normal)
            }
        }
    }
    
    func didItemAdded(isSuccess: Bool) {
        if isSuccess {
            buttonState = .remove
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.bookmarkButton.setImage(UIImage(named: "removeBookmarkButton"), for: .normal)
            }
        }
    }
    
    func didFavoriteCheck(isSuccess: Bool) {
        if isSuccess {
            buttonState = .remove
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                self.bookmarkButton.setImage(UIImage(named: "removeBookmarkButton"), for: .normal)
            }
        }
    }
    
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            let item = detailsViewModel!.getModel()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.coverImage.kf.indicatorType = .activity
                
                if let imageUrl = item.image {
                    let url = URL(string: imageUrl)
                    self.coverImage.kf.setImage(with: url,
                                                placeholder: UIImage(named: "placeholderImage"),
                                                options: [
                                                    .scaleFactor(UIScreen.main.scale),
                                                    .transition(.fade(1)),
                                                    .cacheOriginalImage
                                                ])
                } else {
                    self.coverImage.image = UIImage(named: "noImage")
                }
                
                self.titleLabel.text = item.cellTitle
                self.descriptionLabel.text = item.desc
                self.categoryLabel.text = item.category
            }
        } else {
            // TODO:
        }
    }
}



/* old codes
 
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
 
 }*/
