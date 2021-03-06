//
//  AirportsRepository.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

class AirportsRepository: AirportsRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchAirportList(for city: String, completion: @escaping ([AirportModel]?, Error?) -> Void) {
        networkService.cancelTask()
        let parameters = [
            "term": city,
            "locale": "ru"
        ]
        networkService.request(
            EndPoint(
                baseUrl: AirportsUtility.baseUrl,
                path: AirportsUtility.path,
                httpMethod: .get,
                task: .requestParameters(parameters))) { [weak self] (data, _, error) in
                    guard error == nil, let data = data else {
                        completion(nil, error)
                        return
                    }
                    do {
                        let values = try self?.transform(data: data)
                        completion(values, nil)
                    } catch {
                        completion(nil, error)
                    }
        }
    }
}

private extension AirportsRepository {
    
    func transform(data: Data) throws ->  [AirportModel] {
        do {
            return try JSONDecoder().decode([AirportModel].self, from: data)
        } catch {
            throw error
        }
    }
}
