//
//  HotelDetailsViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class HotelDetailsViewModel {
    private let model: HotelDetailsModel
    
    weak var viewDelegate: DetailsViewModelViewDelegateProtocol?
    
    init(model _model: HotelDetailsModel) {
        model = _model
        model.delegate = self
    }
    
    private func transformHotelToDetailsScreenEntity(from hotel: Hotel) -> DetailsScreenEntity {
        let score = hotel.score
        let category = "Score: \(score!)"
        return DetailsScreenEntity(id: hotel.id,
                                   cellTitle: hotel.name,
                                   desc: hotel.hotelDescription,
                                   image: hotel.image,
                                   category: category)
    }
}

// MARK: - Model Protocol Methods
extension HotelDetailsViewModel: HotelDetailsModelProtocol {
    func didDataRemoveProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didItemRemoved(isSuccess: isSuccess)
    }
    
    func didCheckFavoriteProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didFavoriteCheck(isSuccess: isSuccess)
    }
    
    func didDataAddProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didItemAdded(isSuccess: isSuccess)
    }
    
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didCellItemFetch(isSuccess: isSuccess)
    }
}


// MARK: - View Model Methods Protocol
extension HotelDetailsViewModel: DetailsViewModelMethodsProtocol {
    func removeFromFavoritesBy(id: String) {
        model.removeData(by: id)
    }
    
    func didViewLoad() {
        model.fetchData()
    }
    
    func getModel() -> DetailsScreenEntity {
        // TODO:
        let hotel = model.selectedHotel!
        
        model.isFavorite(by: hotel.id!)
        return transformHotelToDetailsScreenEntity(from: hotel)
    }
    
    func didSaveButtonPressed(newItem: BookmarkItem) {
        model.addItem(newItem)
    }
}
