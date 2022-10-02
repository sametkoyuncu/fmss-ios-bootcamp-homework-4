//
//  HotelDetailsViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class HotelDetailsViewModel {
    private let model = HotelDetailsModel()
    
    weak var viewDelegate: DetailsViewModelViewDelegateProtocol?
    
    init() {
        model.delegate = self
    }
    
    private func transformHotelToDetailsScreenEntity(from hotel: Hotel) -> DetailsScreenEntity {
        let score = hotel.score
        let category = "Score: \(score!)"
        return DetailsScreenEntity(cellTitle: hotel.name,
                              desc: hotel.hotelDescription,
                              image: hotel.image,
                              category: category)
    }
}

// MARK: - Model Protocol Methods
extension HotelDetailsViewModel: HotelDetailsModelProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            // TODO: 
        }
    }
}


// MARK: - View Model Methods Protocol
extension HotelDetailsViewModel: DetailsViewModelMethodsProtocol {
    func didViewLoad(_ selectedId: String) {
        model.fetchDataBy(id: selectedId)
    }
    
    func getModel() -> DetailsScreenEntity {
        // TODO:
        let hotel = model.selectedHotel!
        
        return transformHotelToDetailsScreenEntity(from: hotel)
    }
}
