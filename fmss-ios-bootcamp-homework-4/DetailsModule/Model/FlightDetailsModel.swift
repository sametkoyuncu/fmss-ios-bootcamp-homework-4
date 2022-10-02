//
//  FlightDetailsModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol FlightDetailsModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

class FlightDetailsModel {
    weak var delegate: FlightDetailsModelProtocol?
    
    var selectedFlight: Flight?
    
    func fetchDataBy(id: String) {
        guard let path = Bundle.main.path(forResource: "flights", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Flights.self, from: data)
            
            let flightById = result.filter { $0.flight?.number == id}.first

            selectedFlight = flightById
            delegate?.didDataFetchProcessFinish(true)

        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
