//
//  HotelEntity.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 1.10.2022.
//

struct Hotel: Codable {
    let id, name, hotelDescription, image: String?
    let score: Double?
    let website: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hotelDescription = "description"
        case image, score, website
    }
}

typealias Hotels = [Hotel]
