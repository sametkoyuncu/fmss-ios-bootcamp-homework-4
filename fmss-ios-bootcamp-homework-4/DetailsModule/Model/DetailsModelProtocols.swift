//
//  DetailsModelProtocols.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 6.10.2022.
//

import Foundation

protocol DetailsModelMethodsProtocol {
    var delegate: DetailsModelDelegateProtocol? {get set}
    func fetchData()
    func addItem(_ item: BookmarkItem)
    func removeData(by id: String)
    func isFavorite(by id: String)
}

protocol DetailsModelDelegateProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
    func didDataAddProcessFinish(_ isSuccess: Bool)
    func didDataRemoveProcessFinish(_ isSuccess: Bool)
    func didCheckFavoriteProcessFinish(_ isSuccess: Bool)
}
