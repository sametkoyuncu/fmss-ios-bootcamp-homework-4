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

// MARK: - View Model Methods Protocol
extension FlightListViewModel: ListViewModelMethodsProtocol {

    func didViewLoad() {
        model.fetchData()
        
        // MARK: - api'den veri çekmek için yukarıdaki satırı kapatıp
        //         alttaki satırı aktif hale getirin
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

// MARK: - Model Delegate Methods
extension FlightListViewModel: ListModelDelegateProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didCellItemFetch(isSuccess: true)
    }
}
