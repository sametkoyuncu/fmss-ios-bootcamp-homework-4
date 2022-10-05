//
//  FlightListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class FlightListViewModel {
    private let model: FlightListModel
    
    weak var viewDelegate: ListViewModelViewDelegateProtocol?
    
    init(model _model: FlightListModel) {
        model = _model
        model.delegate = self
    }
    
    // MARK: - Section Heading
    deinit {
        viewDelegate = nil
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
        
        let image = "https://iasbh.tmgrup.com.tr/93bd9c/650/344/0/113/800/533?u=https://isbh.tmgrup.com.tr/sbh/2021/08/06/istanbul-sabiha-gokcen-havalimanini-7-ayda-118-milyon-yolcu-kullandi-1628238800986.jpg"
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
        // MARK: - using alamofire request from flightlabs api
        //model.fetchDataUsingAlamofire()
        
    }
    
    func NumberOfItems() -> Int {
        return model.flights.count
    }
    
    func getModel(at index: Int) -> ListItemEntity {
        let flight = model.flights[index]
        
        return transformFlightToListItemEntity(from: flight)
    }
}
