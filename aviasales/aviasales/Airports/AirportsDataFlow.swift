//
//  AirportsDataFlow.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

struct AirportsDataFlow {
    
    struct FetchAirportList {
        struct Request {
            let city: String
        }
        
        struct Response {
            let models: [AirportModel]
        }
    }
    
    struct Placeholder {
        struct ViewModel {
            let title: String
            let icon: UIImage?
        }
    }
    
    struct InitialState {
        struct ViewModel {
            let cityName: String
            let title: String
            let icon: UIImage?
        }
    }
}
