//
//  AirportsRepositoryProtocol.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

protocol AirportsRepositoryProtocol {
    func fetchAirportList(for city: String, completion: @escaping ([AirportModel]?, Error?) -> Void)
}
