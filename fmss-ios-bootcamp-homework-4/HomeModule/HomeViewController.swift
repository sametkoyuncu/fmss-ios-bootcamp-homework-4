//
//  ViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit

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
    
    func setup() {
        registerCells()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.viewDelegate = self
        viewModel.didViewLoad()
        
        headerView.layer.borderWidth = 0.0
        headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerView.layer.shadowRadius = 5.0
        headerView.layer.shadowOpacity = 1
        headerView.layer.masksToBounds = false
    }
    
    @IBAction func flightsButtonPressed(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: ListViewController.storboardID) as! ListViewController
        
        destinationVC.detailsType = .flights
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func hotelsButtonPressed(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: ListViewController.storboardID) as! ListViewController
        
        destinationVC.detailsType = .hotels
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func registerCells() {
        collectionView.register(.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
    
    
}

// MARK: - Collection View Delegate Methods
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        // id is not working!!
        destinationVC.selectedId = viewModel.getModel(at: indexPath.row).content
        destinationVC.detailsType = .articles
            
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
        
        cell.coverImage.image = UIImage(named: item.image ?? "noImage")
        cell.categoryLabel.text = item.category
        cell.titleLabel.text = item.content
        
        // Configure the cell
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        
        return cell
    }
    
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

extension HomeViewController: ArticleListViewModelViewProtocol {
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
                   DispatchQueue.main.async { [weak self] in
                       self?.collectionView.reloadData()
                   }
               }
    }
}
