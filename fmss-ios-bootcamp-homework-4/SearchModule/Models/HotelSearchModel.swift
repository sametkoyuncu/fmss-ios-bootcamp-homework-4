//
//  HotelSearchModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation

class HotelSearchModel {
    weak var delegate: SearchModelDelegateProtocol?
    
    var hotels: Hotels = []
    
}

extension HotelSearchModel: SearchModelMethodsProtocol {
    func fetchDataBy(searchText: String) {
        guard let path = Bundle.main.path(forResource: "hotels", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Hotels.self, from: data)
            
            let searchList = result.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false || (($0.hotelDescription?.lowercased().contains(searchText.lowercased())) ?? false) }
            
            if searchList.count == 0 {
                delegate?.didDataFetchProcessFinish(false)
            } else {
                hotels = searchList
                delegate?.didDataFetchProcessFinish(true)
            }
            
        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
