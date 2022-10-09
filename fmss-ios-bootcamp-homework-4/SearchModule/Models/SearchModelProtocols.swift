//
//  SearchModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 6.10.2022.
//

import Foundation

// Search Model Methods
protocol SearchModelMethodsProtocol {
    var delegate: SearchModelDelegateProtocol? {get set}
    func fetchDataBy(searchText: String)
}

// Search Model Delegate Methods
protocol SearchModelDelegateProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}
