//
//  FlightDetailsViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class FlightDetailsViewModel {
    private let model: FlightDetailsModel
    var selectedId: String?
    
    weak var viewDelegate: DetailsViewModelViewDelegateProtocol?
    
    init(model _model: FlightDetailsModel) {
        model = _model
        model.delegate = self
    }
    
    // MARK: - Section Heading
    deinit {
        model.delegate = nil
        viewDelegate = nil
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
        
        let image = "saw"
        let category = flight.airline?.callsign?.rawValue

        return DetailsScreenEntity(id: id, cellTitle: title, desc: desc, image: image, category: category)
    }
}

// MARK: - Model Protocol Methods
extension FlightDetailsViewModel: FlightDetailsModelProtocol {
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
        // TODO:
        let flight = model.selectedFlight!
        
        return transformFlightToDetailsScreenEntity(from: flight)
    }
}
