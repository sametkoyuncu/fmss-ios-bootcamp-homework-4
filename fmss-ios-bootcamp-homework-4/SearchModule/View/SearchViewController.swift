//
//  SearchViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    var searchViewModel: SearchViewModelMethodsProtocol?
    // arama yapılacak tab ve değişince ui güncellemesi
    var activeTab: ActiveSearchTab? {
        didSet {
            activeTabChanged()
        }
    }
    // arama ekranının davranışları için state
    // state değiştiği zaman, state'e göre ekranı güncelliyor
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
        setup()
        registerCell()
    }
    
    func setup() {
        // initial states
        activeTab = .hotels
        state = .empty
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        
        // textField'ın sağ tarafına extension ile görsel ekleme işlemi
        if let searchImage = UIImage(named: "searchIcon") {
            searchTextField.withImage(direction: .Right, image: searchImage, colorSeparator: UIColor.clear, colorBorder: UIColor.clear)
        }
    }
    // ekran ilk açıldığında gösterilecek
    func showEmpty() {
        noDataView.isHidden = true
        tableView.isHidden = true
    }
    // arama sonucu varsa gösterilecek
    func showResults() {
        noDataView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    // arama sonucu yoksa gösterilecek
    func showNotFound() {
        tableView.isHidden = true
        DispatchQueue.main.async {
            self.noDataView.isHidden = false
        }
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        // textField'e 3 harf ve daha fazlası girildiyse arama yap
        if searchTextField.text?.count ?? 0 >= 3 {
            if let searchText = searchTextField.text {
                // seçili tab'a göre arama işlemi yap
                switch activeTab {
                case .hotels:
                    searchViewModel = HotelSearchViewModel()
                    searchViewModel?.viewDelegate = self
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self else { return }
                        self.searchViewModel?.didViewLoad(searchText)
                    }
                    
                case .flights:
                    searchViewModel = FlightSearchViewModel()
                    searchViewModel?.viewDelegate = self
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self else { return }
                        self.searchViewModel?.didViewLoad(searchText)
                    }
                case .none:
                    fatalError("there is no active tab")
                }
            }
        } else {
           state = .empty
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
    
    // ekranı güncelleme
    func activeTabChanged() {
        if let activeTab = activeTab {
            state = .empty
            searchTextField.text = ""
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

        let vc = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        
        guard let id = searchViewModel?.getModel(at: indexPath.row).id else { return }
        let detailsType: DataTypeEnum = activeTab == .hotels ? .hotels : .flights
        
        let destinationVC = DetailsModuleBuilder.createModule(with: id, for: detailsType, vc: vc)

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
        
        if let item = item {
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.desc
            
            // image
            cell.coverImage.kf.indicatorType = .activity
            
            let url = URL(string: item.image!)
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
        
        return cell
    }
}

extension SearchViewController: SearchViewModelViewDelegateProtocol {
    // arama sonucuna göre ekranı güncelle
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            state = .success
        } else {
            state = .notFound
        }
    }
}
