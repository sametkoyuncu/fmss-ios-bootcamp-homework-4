//
//  ListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 1.10.2022.
//

import Foundation

class HotelListViewModel {
    private let model: HotelListModel
    
    weak var viewDelegate: ListViewModelViewDelegateProtocol?
    
    init(model _model: HotelListModel) {
        model = _model
        model.delegate = self
    }

    private func transformHotelToListItemEntity(from hotel: Hotel) -> ListItemEntity {
        return ListItemEntity(id: hotel.id,
                              cellTitle: hotel.name,
                              desc: hotel.hotelDescription,
                              image: hotel.image)
    }
}


// MARK: - View Model Methods Protocol
extension HotelListViewModel: ListViewModelMethodsProtocol {

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

// MARK: - Model Delegate Methods
extension HotelListViewModel: ListModelDelegateProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didCellItemFetch(isSuccess: true)
    }
}
