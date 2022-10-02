//
//  ListViewModelDelegateProtocol.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ListViewModelViewDelegateProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
}
