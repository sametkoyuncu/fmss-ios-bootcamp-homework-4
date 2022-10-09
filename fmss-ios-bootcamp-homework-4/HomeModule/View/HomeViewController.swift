//
//  ViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    static let storyboardID = "HomeVC"
    
    private let viewModel = ArticleListViewModel()
    
    // outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.didViewLoad()
    }
   
    // go flights list
    @IBAction func flightsButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ListViewController.storboardID) as! ListViewController
        let destinationVC = ListModuleBuilder.createModule(for: .flights, vc: vc)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    // go hotels list
    @IBAction func hotelsButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ListViewController.storboardID) as! ListViewController
        let destinationVC = ListModuleBuilder.createModule(for: .hotels, vc: vc)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - HomeVC private methods
private extension HomeViewController {
    func setup() {
        registerCells()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.viewDelegate = self
        
        
        // header view shadow
        headerView.layer.borderWidth = 0.0
        headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerView.layer.shadowRadius = 5.0
        headerView.layer.shadowOpacity = 1
        headerView.layer.masksToBounds = false
    }
    
    func registerCells() {
        collectionView.register(.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
}

// MARK: - Collection View Delegate Methods
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        
        guard let id = viewModel.getModel(at: indexPath.row).content else { return }
        let destinationVC = DetailsModuleBuilder.createModule(with: id, for: .articles, vc: vc)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - Collection View DataSource Methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.NumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.getModel(at: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        if let imageUrl = item.image {
            cell.coverImage.kf.indicatorType = .activity
            
            let url = URL(string: imageUrl)
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
        
        item.isFavorite! ? cell.bookmarkIcon.setImage(UIImage(named: "BookmarkFilled"), for: .normal) : cell.bookmarkIcon.setImage(UIImage(named: "Bookmark"), for: .normal)
        
        cell.categoryLabel.text = item.category
        cell.titleLabel.text = item.content
        // 'add to bookmarks' and 'remove from bookmarks' methods
        cell.handleClick = item.isFavorite! ?
        { [weak self] in
            guard let self = self else {return}
            self.viewModel.removeFromFavoritesBy(id: item.id!, row: indexPath.row) } :
        { [weak self] in
            guard let self = self else {return}
            self.viewModel.didBookmarkButtonPressed(newItem: .init(idForSearch: item.id,
                                                               title: item.content,
                                                               description: item.content,
                                                               image: item.image,
                                                               type: .articles),
                                                row: indexPath.row)
        }
        
        return cell
    }
    
    // clear background
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
}

// MARK: - Collection View Delegete Flow Layout Methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width - 100
        let height = collectionView.frame.height - 40
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - View Model Delegate Methods
extension HomeViewController: ArticleListViewModelViewProtocol {
    // veri çekildiyse collection view'ı güncelle
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    // bookmark ekle/sil işleminde sonra cell'i güncelle
    func didItemAdded(isSuccess: Bool, row: Int) {
        if isSuccess {
            collectionView.reloadItems(at: [IndexPath.init(item: row, section: 0)])
        }
    }
    
    func didItemRemoved(isSuccess: Bool, row: Int) {
        if isSuccess {
            collectionView.reloadItems(at: [IndexPath.init(item: row, section: 0)])
        }
    }
}
