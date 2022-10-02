//
//  DetailsViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//
// TODO: view model in delegate i yok gibi
import UIKit

class ListViewController: UIViewController {
    
    static let storboardID = "ListVC"
    
    private var listViewModel: ListViewModelMethodsProtocol?

    var detailsType: DetailsTypeEnum?
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch detailsType {
        case .hotels:
            listViewModel = HotelListViewModel()
        case .flights:
            listViewModel = FlightListViewModel()
        case .articles, .none:
            fatalError("Details Type Not Found! (from viewWillAppear)")
        }
        listViewModel?.didViewLoad()
    }
    
    func setup() {
        if let detailsType = detailsType {
            titleLabel.text = detailsType.rawValue
        } else {
            fatalError("Details Type Not Found! (from viewDidLoad)")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        tableView.separatorStyle = .none
    }
    
    func registerCells() {
        tableView.register(.init(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Delegate Methods
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        
        destinationVC.selectedId = listViewModel?.getModel(at: indexPath.row).id
        destinationVC.detailsType = detailsType
        
            
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - TableView DataSource Methods
extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel!.NumberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listViewModel!.getModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        cell.coverImage.image = UIImage(named: item.image ?? "noImage")
        cell.titleLabel.text = item.cellTitle
        cell.descriptionLabel.text = item.desc
        
        return cell
    }
    // set height for cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    // clear cell background
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
}

// MARK: - bu kullanım çalışmadı ama lazım olur diye kalsın :)

/*private var listViewModel: FlightOrHotelViewModel?

enum FlightOrHotelViewModel {
    case hotelViewModel(HotelListViewModel)
    case flightViewModel(HotelListViewModel)
}*/

/*
override func viewWillAppear(_ animated: Bool) {
    switch detailsType {
    case .hotels:
        listViewModel = .hotelViewModel(HotelListViewModel())
    case .flights:
        // todo
        listViewModel = .flightViewModel(HotelListViewModel())
    case .none:
        return
    }
}*/




