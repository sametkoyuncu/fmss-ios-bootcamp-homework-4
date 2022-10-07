//
//  FlightListModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation
import Alamofire

class FlightListModel {
    weak var delegate: ListModelDelegateProtocol?
    
    var flights: Flights = []
    
    // MARK: - Alamofire request
    func fetchDataUsingAlamofire() {
        let first_API_KEY = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiOTUxOTcyY2YyNzc3YmY2ZjcyNzRhM2Y1ZDg2Mzc0MGJmMzRjN2NhNjJmMDZlNWMwNTU0OTA1Yzg2MjZjNzA1NzQyYTBlZWJjNmJmMDhjZDciLCJpYXQiOjE2NjQ2OTc0NjksIm5iZiI6MTY2NDY5NzQ2OSwiZXhwIjoxNjk2MjMzNDY5LCJzdWIiOiIxNDA5NCIsInNjb3BlcyI6W119.gYQgX0R1skE_yqGLQJv8oVPDk1W-JxA0dI9Ps8BXXrrDXshlvXbDVNRj8Kc4SwyLQfwkfbIcZQP0kEgnAEXCKw"
        // api aylık 100 istek hakkı veriyor
        // eğer istek kotası dolduysa aşağıdaki api key'i kullanın
        let _ = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiOTg0OGRkNTMzZjhjYWRkZGY0NTQ1ZDc4MTVlZDZlNmUwODM0MDRlYmJjNWY4OTY1OGMwOGI0ODhiZTAwZjk4MWYwOGJhMzdmMTIyMDdiMDAiLCJpYXQiOjE2NjQ5NjQ1NzksIm5iZiI6MTY2NDk2NDU3OSwiZXhwIjoxNjk2NTAwNTc5LCJzdWIiOiIxNDM2NCIsInNjb3BlcyI6W119.ZAzU-wDZrwcbHJEyFSwfRe-kIT0zlgOEvZy7EkMQc9KNXyJryHeuE6nEFC6ka7FrOc-9yqkKwRmxrc95jSf4sw"
        // from airport
        let departureIATAcode = "SAW"
        // to airport
        let arrivalIATAcode = "ESB"
        
        AF.request("https://app.goflightlabs.com/routes?access_key=\(first_API_KEY)&dep_iata=\(departureIATAcode)&arr_iata=\(arrivalIATAcode)").response { response in
            do {
                guard let data = response.data else { return }

                let result = try JSONDecoder().decode(Flights.self, from: data)
                
                self.flights = result
                self.delegate?.didDataFetchProcessFinish(true)

            } catch {
                print(error.localizedDescription)
                self.delegate?.didDataFetchProcessFinish(false)
            }
        }
    }
}

extension FlightListModel: ListModelMethodsProtocol {
    func fetchData() {
        guard let path = Bundle.main.path(forResource: "flights", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Flights.self, from: data)
            flights = result
            delegate?.didDataFetchProcessFinish(true)

        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
