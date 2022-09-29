//
//  ViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit

class HomeViewController: UIViewController {
    static let storyboardID = "HomeVC"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerView.layer.borderWidth = 0.0
        headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerView.layer.shadowRadius = 5.0
        headerView.layer.shadowOpacity = 1
        headerView.layer.masksToBounds = false
    }
    @IBAction func flightsButtonPressed(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storboardID) as! DetailsViewController
        destinationVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    @IBAction func hotelsButtonPressed(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storboardID) as! DetailsViewController
        
        present(destinationVC, animated: true)
    }
    
    func registerCells() {
        collectionView.register(.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
    
    
}

// MARK: - Collection View Delegate Methods
extension HomeViewController: UICollectionViewDelegate {

}

// MARK: - Collection View DataSource Methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath)
        
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
