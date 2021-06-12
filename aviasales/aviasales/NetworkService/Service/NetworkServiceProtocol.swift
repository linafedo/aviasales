//
//  NNetworkServiceProtocol.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]
typealias NetworkServiceCompletion = (_ data: Data?, _ response: NetworkResponse?, _ error: Error?) -> ()

protocol NetworkServiceProtocol {
    func request(_ route: EndPoint, completion: @escaping NetworkServiceCompletion)
    func cancelTask()
}
