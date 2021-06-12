//
//  UseCase.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

struct Airports {
    
    struct FetchAirportList {
        struct Request {
            let city: String
        }
        
        struct Response {
            let models: [AirportModel]
        }
    }

}
