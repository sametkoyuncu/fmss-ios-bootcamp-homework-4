//
//  BookmarksViewController.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import UIKit

class BookmarksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func registerCell() {
        tableView.register(.init(nibName: "BookmarksTableViewCell", bundle: nil), forCellReuseIdentifier: BookmarksTableViewCell.identifier)
    }

}

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyboardID) as! DetailsViewController
        // TODO: burası değişecek
        destinationVC.detailsType = .flights
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarksTableViewCell.identifier, for: indexPath) as! BookmarksTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146.0
    }
    
}
