//
//  SearchViewModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation
// Search View Model Methods
protocol SearchViewModelMethodsProtocol: AnyObject {
    var viewDelegate: SearchViewModelViewDelegateProtocol? {get set}
    
    func didViewLoad(_ searchText: String)
    func NumberOfItems() -> Int
    func getModel(at index: Int) -> SearchCellEntity
}

// Search View Model Delegate Methods
protocol SearchViewModelViewDelegateProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
}
