//
//  FlightSearchModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation

class FlightSearchModel {
    weak var delegate: SearchModelDelegateProtocol?
    
    var flights: Flights = []

}

extension FlightSearchModel: SearchModelMethodsProtocol {
    func fetchDataBy(searchText: String) {
        guard let path = Bundle.main.path(forResource: "flights", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Flights.self, from: data)
            
            let searchList = result.filter {
                $0.flight?.number?.lowercased().contains(searchText.lowercased()) ?? false ||
                $0.airline?.callsign?.rawValue.lowercased().contains(searchText.lowercased()) ?? false ||
                $0.departure?.airport?.rawValue.lowercased().contains(searchText.lowercased()) ?? false ||
                $0.arrival?.airport?.rawValue.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            if searchList.count == 0 {
                delegate?.didDataFetchProcessFinish(false)
            } else {
                flights = searchList
                delegate?.didDataFetchProcessFinish(true)
            }
            
        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
