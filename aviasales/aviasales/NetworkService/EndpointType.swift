//
//  EndpointType.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

struct EndPoint {
    let baseUrl: String
    let path: String
    let httpMethod: HTTPMethod
    let task: HTTPTask
}
