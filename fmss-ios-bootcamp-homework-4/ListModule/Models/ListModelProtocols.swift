//
//  ListModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 6.10.2022.
//

import Foundation

protocol ListModelMethodsProtocol {
    var delegate: ListModelDelegateProtocol? {get set}
    func fetchData()
}

protocol ListModelDelegateProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

