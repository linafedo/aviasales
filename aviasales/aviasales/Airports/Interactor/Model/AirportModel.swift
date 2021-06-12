//
//  AirportModel.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

struct AirportModel {
    let airportName: String?
    let name: String
    let location: LocationModel
    let iata: String
}

extension AirportModel: Codable {
    enum CodingKeys: String, CodingKey {
        case airportName = "airport_name"
        case name
        case location
        case iata
    }
}
