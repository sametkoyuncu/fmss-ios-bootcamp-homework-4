//
//  DetailsViewModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol DetailsViewModelMethodsProtocol {
    var viewDelegate: DetailsViewModelViewDelegateProtocol? {get set}
    
    func didViewLoad()
    func getModel() -> DetailsScreenEntity
    func didSaveButtonPressed(newItem: BookmarkItem)
    func removeFromFavoritesBy(id: String)
}

protocol DetailsViewModelViewDelegateProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
    func didItemAdded(isSuccess: Bool)
    func didItemRemoved(isSuccess: Bool)
    func didFavoriteCheck(isSuccess: Bool)
}
