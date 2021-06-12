//
//  LocationModel.swift
//  aviasales
//
//  Created by Galina Fedorova on 11.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

struct LocationModel {
    let latitude: Double
    let longitude: Double
}

extension LocationModel: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
