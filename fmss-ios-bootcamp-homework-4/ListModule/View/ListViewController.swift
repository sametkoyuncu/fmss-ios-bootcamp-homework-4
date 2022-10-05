//
//  DetailsViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//
// TODO: burada memory leak olması kuvvetle muhtemel
import UIKit
import Kingfisher

class ListViewController: UIViewController {
    
    static let storboardID = "ListVC"
    
    var listViewModel: ListViewModelMethodsProtocol?

    var detailsType: DetailsTypeEnum?
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        registerCells()
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        
        guard let id = listViewModel?.getModel(at: indexPath.row).id else { return }
        
        guard let detailsType = detailsType else { return }
        
        let destinationVC = DetailsModuleBuilder.createModule(with: id, for: detailsType, vc: vc)

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

extension ListViewController: ListViewModelViewDelegateProtocol {
    func didCellItemFetch(isSuccess: Bool) {
        if isSuccess {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.tableView.reloadData()
            }
        } else {
            // TODO:
        }
    }
    
    
}

// MARK: - bu kullanım çalışmadı ama lazım olur diye kalsın :)

/*private var listViewModel: FlightOrHotelViewModel?

enum FlightOrHotelViewModel {
    case hotelViewModel(HotelListViewModel)
    case flightViewModel(FlightListViewModel)
}*/

/*
override func viewWillAppear(_ animated: Bool) {
    switch detailsType {
    case .hotels:
        listViewModel = .hotelViewModel(HotelListViewModel())
    case .flights:
        // todo
        listViewModel = .flightViewModel(FlightListViewModel())
    case .none:
        return
    }
}*/




/*
override func viewWillAppear(_ animated: Bool) {
    switch detailsType {
    case .hotels:
        listViewModel = HotelListViewModel()
    case .flights:
        listViewModel = FlightListViewModel()
    case .articles, .none:
        fatalError("Details Type Not Found! (from viewWillAppear)")
    }
    listViewModel?.viewDelegate = self
    listViewModel?.didViewLoad()
}*/
