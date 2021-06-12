//
//  AirportsPresenter.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

protocol AirportsPresenterProtocol {
    func presentAirportList(response: Airports.FetchAirportList.Response)
    func presentEmpty()
    func presentLoading()
}

class AirportsPresenter: AirportsPresenterProtocol {
    
    private let viewController: AirportsListViewProtocol
    
    init(viewController: AirportsListViewProtocol) {
        self.viewController = viewController
    }
    
    func presentAirportList(response: Airports.FetchAirportList.Response) {
        let viewModels = transformToViewModel(models: response.models)
        DispatchQueue.main.async {
            self.viewController.displayAirportList(viewModels: viewModels)
        }
    }
    
    func presentEmpty() {
        DispatchQueue.main.async {
            self.viewController.displayEmpty()
        }
    }
    
    func presentLoading() {
        viewController.displayLoading()
    }
}

private extension AirportsPresenter {
    
    func transformToViewModel(models: [AirportModel]) -> [AirportViewModel] {
        models.map({
            AirportViewModel(
                airportName: $0.airportName,
                name: $0.name,
                latitude: $0.location.latitude,
                longitude: $0.location.longitude,
                iata: $0.iata
            )
        })
    }
}
