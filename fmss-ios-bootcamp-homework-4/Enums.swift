//
//  Enums.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 30.09.2022.
//

import Foundation


enum DetailsTypeEnum: String  {
    case flights = "Flights"
    case hotels = "Hotels"
    case articles = "Articles"
}

enum ActiveSearchTab {
    case hotels
    case flights
}

enum SearchStates {
    case empty
    case success
    case notFound
}
