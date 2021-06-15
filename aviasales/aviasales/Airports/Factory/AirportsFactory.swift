//
//  AirportsFactory.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

class AirportsFactory {
    
    func build() -> UIViewController {
        let presenter = AirportsPresenter()
        let interactor = AirportsInteractor(presenter: presenter)
        let viewController = AirportsListViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
