//
//  DetailsViewModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol DetailsViewModelMethodsProtocol {
    var viewDelegate: DetailsViewModelViewDelegateProtocol? {get set}
    func didViewLoad(_ id: String)
    func getModel() -> DetailsScreenEntity
}

protocol DetailsViewModelViewDelegateProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
}
