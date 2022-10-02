//
//  ListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 1.10.2022.
//

import Foundation

class HotelListViewModel {
    private let model = HotelListModel()
    
    weak var viewDelegate: ListViewModelViewDelegateProtocol?
    
    init() {
        model.delegate = self
    }
    
    private func transformHotelToListItemEntity(from hotel: Hotel) -> ListItemEntity {
        return ListItemEntity(id: hotel.id,
                              cellTitle: hotel.name,
                              desc: hotel.hotelDescription,
                              image: hotel.image)
    }
}

// MARK: - Model Protocol Methods
extension HotelListViewModel: HotelListModelProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            // else
        }
    }
}

// MARK: - View Model Methods Protocol
extension HotelListViewModel: ListViewModelMethodsProtocol {
    // view yüklendiyse data çek
    func didViewLoad() {
        model.fetchData()
    }
    
    func NumberOfItems() -> Int {
        return model.hotels.count
    }
    
    func getModel(at index: Int) -> ListItemEntity {
        let hotel = model.hotels[index]
        
        return transformHotelToListItemEntity(from: hotel)
    }
}
