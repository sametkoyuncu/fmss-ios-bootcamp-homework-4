//
//  ListViewModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ListViewModelMethodsProtocol {
    func didViewLoad()
    func NumberOfItems() -> Int
    func getModel(at: Int) -> ListItemEntity
}

protocol ListViewModelViewDelegateProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
}
