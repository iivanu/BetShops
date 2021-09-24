//
//  BetShops.swift
//  BetShops
//
//  Created by Ivan Ivanušić on 27.08.2021..
//

import Foundation

// MARK: - BetShops
struct BetShops: Codable {
    let count: Int
    let betshops: [BetShop]
}

// MARK: - Betshop
struct BetShop: Codable, Hashable {
    static func == (lhs: BetShop, rhs: BetShop) -> Bool {
        return lhs.id == rhs.id
    }
    
    let name: String
    let location: Location
    let id: Int
    let country: String
    let cityID: Int
    let city, address: String

    enum CodingKeys: String, CodingKey {
        case name, location, id
        case country = "county"
        case cityID = "city_id"
        case city, address
    }
}

// MARK: - Location
struct Location: Codable, Hashable {
    let lng, lat: Double
}

