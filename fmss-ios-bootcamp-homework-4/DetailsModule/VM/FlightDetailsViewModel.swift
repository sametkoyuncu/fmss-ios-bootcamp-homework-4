//
//  FlightDetailsViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class FlightDetailsViewModel {
    private let model: FlightDetailsModel
    
    weak var viewDelegate: DetailsViewModelViewDelegateProtocol?
    
    init(model _model: FlightDetailsModel) {
        model = _model
        model.delegate = self
    }
    
    private func transformFlightToDetailsScreenEntity(from flight: Flight) -> DetailsScreenEntity {
        let id = flight.flight?.number
        let title = "Flight Number: \(flight.flight?.number ?? "")"
        //  description details
        let from = flight.departure?.airport?.rawValue
        let to = flight.arrival?.airport?.rawValue
        let time = flight.departure?.time
        let airline = flight.airline?.name?.rawValue
        // create description
        let desc = """
            From: \(from ?? "No departure")
            To: \(to ?? "No arrival")
            Time: \(time ?? "No time")
            Airline: \(airline ?? "No airline")
        """
        
        let image = "https://iasbh.tmgrup.com.tr/93bd9c/650/344/0/113/800/533?u=https://isbh.tmgrup.com.tr/sbh/2021/08/06/istanbul-sabiha-gokcen-havalimanini-7-ayda-118-milyon-yolcu-kullandi-1628238800986.jpg"
        let category = flight.airline?.callsign?.rawValue

        return DetailsScreenEntity(id: id, cellTitle: title, desc: desc, image: image, category: category)
    }
}

// MARK: - Model Protocol Methods
extension FlightDetailsViewModel: DetailsModelDelegateProtocol {
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
extension FlightDetailsViewModel: DetailsViewModelMethodsProtocol {
    func removeFromFavoritesBy(id: String) {
        model.removeData(by: id)
    }
    
    func didSaveButtonPressed(newItem: BookmarkItem) {
        model.addItem(newItem)
    }
    
    func didViewLoad() {
        model.fetchData()
    }
    
    func getModel() -> DetailsScreenEntity {
        let flight = model.selectedFlight!
        
        // bookmark kontrolü için olayı başlat
        model.isFavorite(by: flight.flight!.number!)
        return transformFlightToDetailsScreenEntity(from: flight)
    }
}
