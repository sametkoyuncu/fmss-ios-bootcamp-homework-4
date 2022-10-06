//
//  HotelListModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 1.10.2022.
//

import Foundation

class HotelListModel {
    weak var delegate: ListModelDelegateProtocol?
    
    var hotels: Hotels = []
}

extension HotelListModel: ListModelMethodsProtocol {
    func fetchData() {
        guard let path = Bundle.main.path(forResource: "hotels", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Hotels.self, from: data)

            hotels = result
            
            delegate?.didDataFetchProcessFinish(true)

        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
