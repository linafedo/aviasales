//
//  AirplaneMovementPresenter.swift
//  aviasales
//
//  Created by Galina Fedorova on 13.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

protocol AirplaneMovementPresenterProtocol {
    func presentInitialState(response: AirplaneMovementDataFlow.InitialState.Response)
}

class AirplaneMovementPresenter: AirplaneMovementPresenterProtocol {
    
    weak var viewController: AirplaneMovementViewProtocol?
    
    func presentInitialState(response: AirplaneMovementDataFlow.InitialState.Response) {
        viewController?.displayInitialState(
            viewModel: .init(
                fromLocation: .init(
                    iata: response.model.fromLocation.iata,
                    latitude: response.model.fromLocation.latitude,
                    longitude: response.model.fromLocation.longitude),
                toLocation: .init(
                    iata: response.model.toLocation.iata,
                    latitude: response.model.toLocation.latitude,
                    longitude: response.model.toLocation.longitude)
        ))
    }
}
