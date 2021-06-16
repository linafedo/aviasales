//
//  AirplaneMovementFactory.swift
//  aviasales
//
//  Created by Galina Fedorova on 13.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

class AirplaneMovementFactory {
    
    func build(toLatitude: Double, toLongitude: Double, iata: String) -> UIViewController {
        let model = AirplaneMovementModel(
            fromLocation: .init(
                iata: Utility.iata,
                latitude: Utility.startLatitude,
                longitude: Utility.startLongitude),
            toLocation: .init(iata: iata, latitude: toLatitude, longitude: toLongitude))
        let presenter = AirplaneMovementPresenter()
        let interactor = AirplaneMovementInteractor(movementModel: model, presenter: presenter)
        let viewController = AirplaneMovementViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
