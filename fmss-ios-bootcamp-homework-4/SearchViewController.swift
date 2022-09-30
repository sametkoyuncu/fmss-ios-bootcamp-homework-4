//
//  SearchViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
   
    
    var activeTab: ActiveSearchTab? {
        didSet {
            activeTabChanged()
        }
    }
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hotelsButton: UIButton!
    @IBOutlet weak var flightsButton: UIButton!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeTab = .hotels
        
        registerCell()
        
        noDataView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func hotelsButtonPressed(_ sender: UIButton) {
        activeTab = .hotels
    }
    
    @IBAction func flightsButtonPressed(_ sender: UIButton) {
        activeTab = .flights
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
    func registerCell() {
        tableView.register(.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func activeTabChanged() {
        if let activeTab = activeTab {
            switch activeTab {
            case .hotels:
                hotelsButton.setImage(UIImage.init(named: "home tab active")!, for: .normal)
                flightsButton.setImage(UIImage.init(named: "flights tab passive")!, for: .normal)
            case .flights:
                hotelsButton.setImage(UIImage.init(named: "home tab passive")!, for: .normal)
                flightsButton.setImage(UIImage.init(named: "flights tab active")!, for: .normal)
            }
        }
        
    }
}


// MARK: - table view delegate methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        // TODO: burası değişecek
        destinationVC.detailsType = .hotels
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - table view datasource methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    
}
