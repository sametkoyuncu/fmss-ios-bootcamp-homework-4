//
//  CoinManager.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 1.10.2022.
//

import Foundation

class CoinManager {
    static func getCoins() {
        print("get coins çalıştı")
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            print("getCoins guard path")
            return
        }
        
        let pathURL = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: pathURL)
            
            //let data = try String(contentsOfFile: path).data(using: .utf8)
            let result = try JSONDecoder().decode(Coin.self, from: data)
            print(result)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
}
