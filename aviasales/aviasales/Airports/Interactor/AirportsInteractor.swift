//
//  AirportsInteractor.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

protocol AirportsInteractorProtocol {
    func fetchAirportList(request: AirportsDataFlow.FetchAirportList.Request)
    func setupInitialState()
    func checkPlace(request: AirportsDataFlow.CheckPlace)
}

class AirportsInteractor: AirportsInteractorProtocol {
    
    private let repository: AirportsRepositoryProtocol
    let presenter: AirportsPresenterProtocol
    
    init(
        repository: AirportsRepositoryProtocol = AirportsRepository(),
        presenter: AirportsPresenterProtocol
    ) {
        self.repository = repository
        self.presenter = presenter
    }
    
    func setupInitialState() {
        presenter.presentInitialState() 
    }

    func fetchAirportList(request: AirportsDataFlow.FetchAirportList.Request) {
        presenter.presentLoading()
        repository.fetchAirportList(for: request.city) { [weak self] airportModels, error in
            guard let models = airportModels, error == nil else {
                self?.presenter.presentError()
                return
            }
            airportModels?.isEmpty == true
                ? self?.presenter.presentEmpty()
                : self?.presenter.presentAirportList(response:
                AirportsDataFlow.FetchAirportList.Response(models: models)
            )
        }
    }
    
    func checkPlace(request: AirportsDataFlow.CheckPlace) {
        if request.name == Utility.cityName {
            presenter.presentCityError()
        } else {
            presenter.presentRoute(response: request)
        }
    }
}
