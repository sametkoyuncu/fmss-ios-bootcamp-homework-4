//
//  ListModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 6.10.2022.
//

import Foundation
// model methods
protocol ListModelMethodsProtocol {
    var delegate: ListModelDelegateProtocol? {get set}
    func fetchData()
}

// model delegate methods
protocol ListModelDelegateProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

