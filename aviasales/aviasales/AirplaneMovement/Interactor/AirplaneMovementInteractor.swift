//
//  AirplaneMovementInteractor.swift
//  aviasales
//
//  Created by Galina Fedorova on 13.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

protocol AirplaneMovementInteractorProtocol {
    func loadInitialState()
}

class AirplaneMovementInteractor: AirplaneMovementInteractorProtocol {
    
    private let presenter: AirplaneMovementPresenterProtocol
    private let movementModel: AirplaneMovementModel
    
    init(movementModel: AirplaneMovementModel,
         presenter: AirplaneMovementPresenterProtocol) {
        self.movementModel = movementModel
        self.presenter = presenter
    }
    
    func loadInitialState() {
        let fromLocation = AirplaneMovementLocationModel(
            iata: movementModel.fromLocation.iata,
            latitude: movementModel.fromLocation.latitude,
            longitude:  movementModel.fromLocation.longitude
        )
        let toLocation = AirplaneMovementLocationModel(
            iata: movementModel.toLocation.iata,
            latitude: movementModel.toLocation.latitude,
            longitude: movementModel.toLocation.longitude
        )
        presenter.presentInitialState(response: .init(
            model: .init(fromLocation: fromLocation, toLocation: toLocation)
        ))
    }
}
