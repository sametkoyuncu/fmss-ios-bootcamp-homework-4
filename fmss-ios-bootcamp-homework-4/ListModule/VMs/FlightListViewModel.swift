//
//  FlightListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class FlightListViewModel {
    private let model = FlightListModel()
    
    weak var viewDelegate: ListViewModelViewDelegateProtocol?
    
    init() {
        model.delegate = self
    }
    
    private func transformFlightToListItemEntity(from flight: Flight) -> ListItemEntity {
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
        // TODO: uçuşlarda id yerine uçuş numarası olacak
        return ListItemEntity(id: flight.flight?.number, cellTitle: title, desc: desc, image: image)
    }
}

// MARK: - Model Protocol Methods
extension FlightListViewModel: FlightListModelProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            // else
        }
    }
}

// MARK: - View Model Methods Protocol
extension FlightListViewModel: ListViewModelMethodsProtocol {
    // view yüklendiyse data çek
    func didViewLoad() {
        model.fetchData()
    }
    
    func NumberOfItems() -> Int {
        return model.flights.count
    }
    
    func getModel(at index: Int) -> ListItemEntity {
        let flight = model.flights[index]
        
        return transformFlightToListItemEntity(from: flight)
    }
}
