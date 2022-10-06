//
//  BookmarksViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit
import Kingfisher

class BookmarksViewController: UIViewController {
    
    private var viewModel = BookmarkListViewModel()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.viewDelegate = self
        
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewDidLoad()
    }
    
    func registerCell() {
        tableView.register(.init(nibName: "BookmarksTableViewCell", bundle: nil), forCellReuseIdentifier: BookmarksTableViewCell.identifier)
    }

}

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        let selectedItem = viewModel.getModel(at: indexPath.row)
        guard let id = selectedItem.idForSearch else { return }
        guard let type =  selectedItem.type else { return }
        
        let destinationVC = DetailsModuleBuilder.createModule(with: id, for: type, vc: vc)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarksTableViewCell.identifier, for: indexPath) as! BookmarksTableViewCell
        
        if let imageUrl = item.image {
            let url = URL(string: imageUrl)
            cell.coverImage.kf.indicatorType = .activity
            
            cell.coverImage.kf.setImage(with: url,
                                        placeholder: UIImage(named: "placeholderImage"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                        ])
        } else {
            cell.coverImage.image = UIImage(named: "noImage")
        }
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        
        var category: String?
        
        switch item.type {
        case .hotels:
            category = "HOTEL"
        case .flights:
            category = "FLIGHT"
        default:
            category = "ARTICLE"
        }
        
        cell.categoryLabel.text = category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146.0
    }
    
}

extension BookmarksViewController: BookmarkListViewModelProtocol {
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }
        }
    }
    
    
}
