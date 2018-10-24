//
//  HNB exchange.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation

typealias HNB = [HNBElement]

struct HNBElement: Codable {
    let sellingRate, buyingRate, medianRate, currencyCode: String
    let unitValue: Int
    
    enum CodingKeys: String, CodingKey {
        case sellingRate = "selling_rate"
        case buyingRate = "buying_rate"
        case medianRate = "median_rate"
        case currencyCode = "currency_code"
        case unitValue = "unit_value"
    }
}
