//
//  DetailsViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 29.09.2022.
//

import UIKit

class ListViewController: UIViewController {
    
    static let storboardID = "ListVC"
    
    var detailsType: DetailsTypeEnum?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        if let detailsType = detailsType {
            titleLabel.text = detailsType.rawValue
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.separatorStyle = .none
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func registerCells() {
        tableView.register(.init(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }

}

// MARK: - TableView Delegate Methods
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        
        destinationVC.detailsType = detailsType
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - TableView DataSource Methods
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
}
