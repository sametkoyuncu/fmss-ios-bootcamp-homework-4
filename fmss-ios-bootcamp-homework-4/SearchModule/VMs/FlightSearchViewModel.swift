//
//  FlightSearchViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation

class FlightSearchViewModel {
    private let model = FlightSearchModel()
    
    weak var viewDelegate: SearchViewModelViewDelegateProtocol?
    
    init() {
        model.delegate = self
    }
    
    private func transformFlightToSearchCellEntity(from flight: Flight) -> SearchCellEntity {
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

        
        return SearchCellEntity(id: id, title: title, desc: desc, image: image)
    }
}

// MARK: - Model Protocol Methods
extension FlightSearchViewModel: FlightSearchModelProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            viewDelegate?.didCellItemFetch(isSuccess: false)
        }
    }
}

// MARK: - View Model Methods Protocol
extension FlightSearchViewModel: SearchViewModelMethodsProtocol {
    func getModel(at index: Int) -> SearchCellEntity {
        let flight = model.flights[index]
        
        return transformFlightToSearchCellEntity(from: flight)
    }
    
    func didViewLoad(_ searchText: String) {
        model.fetchDataBy(searchText: searchText)
    }
    
    func NumberOfItems() -> Int {
        return model.flights.count
    }
}
