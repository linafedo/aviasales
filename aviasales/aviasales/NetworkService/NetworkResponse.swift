//
//  NetworkResponse.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case badRequest
    case failed
    case serverError
    
    static func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse {
        switch response.statusCode {
        case 200...299: return .success
        case 400...499: return .badRequest
        case 500...599: return .serverError
        default: return .failed
        }
    }
}
