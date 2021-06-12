//
//  AirportsFactory.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

class AirportsFactory {
    
    static func build() -> UIViewController {
        let viewController = AirportsListViewController()
        let presenter = AirportsPresenter(viewController: viewController)
        let interactor = AirportsInteractor(presenter: presenter)
        viewController.interactor = interactor
        return viewController
    }
}
