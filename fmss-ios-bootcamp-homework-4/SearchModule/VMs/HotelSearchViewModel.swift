//
//  HotelSearchViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation

class HotelSearchViewModel {
    private let model = HotelSearchModel()
    
    weak var viewDelegate: SearchViewModelViewDelegateProtocol?
    
    init() {
        model.delegate = self
    }
    
    private func transformHotelToSearchCellEntity(from hotel: Hotel) -> SearchCellEntity {
        return SearchCellEntity(id: hotel.id,
                                title: hotel.name,
                                desc: hotel.hotelDescription,
                                image: hotel.image)
    }
}

// MARK: - Model Protocol Methods
extension HotelSearchViewModel: SearchModelDelegateProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            viewDelegate?.didCellItemFetch(isSuccess: false)
        }
    }
}

// MARK: - View Model Methods Protocol
extension HotelSearchViewModel: SearchViewModelMethodsProtocol {
    func getModel(at index: Int) -> SearchCellEntity {
        let hotel = model.hotels[index]
        
        return transformHotelToSearchCellEntity(from: hotel)
    }
    
    func didViewLoad(_ searchText: String) {
        model.fetchDataBy(searchText: searchText)
    }
    
    func NumberOfItems() -> Int {
        return model.hotels.count
    }
}
