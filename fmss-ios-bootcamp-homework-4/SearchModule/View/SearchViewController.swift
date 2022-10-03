//
//  SearchViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchViewModel: SearchViewModelMethodsProtocol?
    
    var activeTab: ActiveSearchTab? {
        didSet {
            activeTabChanged()
        }
    }
    
    var state: SearchStates? {
        didSet {
            switch state {
            case .empty:
                showEmpty()
            case .success:
                showResults()
            case .notFound:
                showNotFound()
            case .none:
                fatalError("search state not found")
            }
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
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        state = .empty
        
    }
    
    func showEmpty() {
        noDataView.isHidden = true
        tableView.isHidden = true
        searchTextField.text = ""
    }
    
    func showResults() {
        noDataView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func showNotFound() {
        tableView.isHidden = true
        DispatchQueue.main.async {
            
            self.noDataView.isHidden = false
        }
        
        
    }
    @IBAction func textChanged(_ sender: UITextField) {
        if searchTextField.text?.count ?? 0 >= 3 {
            if let searchText = searchTextField.text {
                switch activeTab {
                case .hotels:
                    searchViewModel = HotelSearchViewModel()
                    searchViewModel?.viewDelegate = self
                    searchViewModel?.didViewLoad(searchText)
                case .flights:
                    searchViewModel = FlightSearchViewModel()
                    searchViewModel?.viewDelegate = self
                    searchViewModel?.didViewLoad(searchText)
                case .none:
                    // TODO:
                    fatalError("there is no active tab")
                }
                state = .success
                // state = .notFound
            }
            
        }
    }
    
    @IBAction func hotelsButtonPressed(_ sender: UIButton) {
        activeTab = .hotels
    }
    
    @IBAction func flightsButtonPressed(_ sender: UIButton) {
        activeTab = .flights
    }
    
    func registerCell() {
        tableView.register(.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func activeTabChanged() {
        if let activeTab = activeTab {
            state = .empty
            
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
        
        destinationVC.selectedId = searchViewModel?.getModel(at: indexPath.row).id
        destinationVC.detailsType = activeTab == .hotels ? .hotels : .flights
        
            
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - table view datasource methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel?.NumberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchViewModel?.getModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.coverImage.image = UIImage(named: item?.image ?? "noImage")
        cell.titleLabel.text = item?.title
        cell.descriptionLabel.text = item?.desc
        
        return cell
    }
    
    
}

extension SearchViewController: SearchViewModelViewDelegateProtocol {
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            state = .success
        } else {
            state = .notFound
        }
    }
}
