// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let coin = try? newJSONDecoder().decode(Coin.self, from: jsonData)

import Foundation

// MARK: - CoinElement
struct CoinElement: Codable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice: Double?
    let marketCap, marketCapRank: Int?
    let fullyDilutedValuation: Int?
    let totalVolume, high24H, low24H, priceChange24H: Double?
    let priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    let totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let roi: Roi?
    let lastUpdated: String?
    let priceChangePercentage24HInCurrency: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice
        case marketCap
        case marketCapRank
        case fullyDilutedValuation
        case totalVolume
        case high24H
        case low24H
        case priceChange24H
        case priceChangePercentage24H
        case marketCapChange24H
        case marketCapChangePercentage24H
        case circulatingSupply
        case totalSupply
        case maxSupply
        case ath
        case athChangePercentage
        case athDate
        case atl
        case atlChangePercentage
        case atlDate
        case roi
        case lastUpdated
        case priceChangePercentage24HInCurrency
    }
}

// MARK: - Roi
struct Roi: Codable {
    let times: Double?
    let currency: Currency?
    let percentage: Double?
}

enum Currency: String, Codable {
    case btc = "btc"
    case eth = "eth"
    case usd = "usd"
}

typealias Coin = [CoinElement]
