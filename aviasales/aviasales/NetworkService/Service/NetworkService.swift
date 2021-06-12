//
//  NetworkService.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkServiceCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try buildRequest(from: route)
            self.task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response as? HTTPURLResponse {
                    let result = NetworkResponse.handleNetworkResponse(response)
                    completion(data, result, nil)
                    
                } else {
                    completion(data, nil, error)
                }
            })
                
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancelTask() {
        self.task?.cancel()
    }
}

// MARK: - Utility

private extension NetworkService {
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        guard let url = URL(string: route.baseUrl) else { throw NetworkError.missingUrl }
        var request = URLRequest(url: url.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .requestParameters(let parameters):
                try configureParameters(parameters: parameters, request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    func configureParameters(parameters: Parameters, request: inout URLRequest) throws {
        do {
            try URLParameterEncoding.encode(urlRequest: &request, with: parameters)
        } catch {
            throw error
        }
    }
}
