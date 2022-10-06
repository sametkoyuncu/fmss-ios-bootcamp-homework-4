//
//  SearchModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 6.10.2022.
//

import Foundation

protocol SearchModelMethodsProtocol {
    var delegate: SearchModelDelegateProtocol? {get set}
    func fetchDataBy(searchText: String)
}

protocol SearchModelDelegateProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}
