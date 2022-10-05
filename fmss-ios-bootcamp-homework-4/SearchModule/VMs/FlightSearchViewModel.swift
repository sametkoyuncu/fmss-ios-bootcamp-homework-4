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
    
    // MARK: - Section Heading
    deinit {
        model.delegate = nil
        viewDelegate = nil
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
        
        let image = "https://iasbh.tmgrup.com.tr/93bd9c/650/344/0/113/800/533?u=https://isbh.tmgrup.com.tr/sbh/2021/08/06/istanbul-sabiha-gokcen-havalimanini-7-ayda-118-milyon-yolcu-kullandi-1628238800986.jpg"

        
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
