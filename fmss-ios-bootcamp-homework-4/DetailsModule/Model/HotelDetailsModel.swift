//
//  HotelDetailsModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol HotelDetailsModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

class HotelDetailsModel {
    weak var delegate: HotelDetailsModelProtocol?
    
    var selectedHotel: Hotel?
    
    func fetchDataBy(id: String) {
        guard let path = Bundle.main.path(forResource: "hotels", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Hotels.self, from: data)
            
            let hotelById = result.filter { $0.id == id }.first

            selectedHotel = hotelById
            delegate?.didDataFetchProcessFinish(true)

        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
