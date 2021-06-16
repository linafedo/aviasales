//
//  AirportsPresenter.swift
//  aviasales
//
//  Created by Galina Fedorova on 10.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

protocol AirportsPresenterProtocol {
    func presentAirportList(response: AirportsDataFlow.FetchAirportList.Response)
    func presentEmpty()
    func presentLoading()
    func presentInitialState()
    func presentError()
    func presentRoute(response: AirportsDataFlow.CheckPlace)
    func presentCityError()
}

class AirportsPresenter: AirportsPresenterProtocol {
    
    weak var viewController: AirportsListViewProtocol?
    
    func presentAirportList(response: AirportsDataFlow.FetchAirportList.Response) {
        let viewModels = transformToViewModel(models: response.models)
        DispatchQueue.main.async {
            self.viewController?.displayAirportList(viewModels: viewModels)
        }
    }
    
    func presentEmpty() {
        DispatchQueue.main.async {
            self.viewController?.displayEmpty(
                viewModel: .init(
                    title: "Не нашли",
                    icon: UIImage(named: "smile")
                )
            )
        }
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    func presentInitialState() {
        viewController?.displayInitialState(
            viewModel: .init(
                cityName: Utility.cityName,
                title: "Начните поиск",
                icon: UIImage(named: "airplane")
            )
        )
    }
    
    func presentError() {
        DispatchQueue.main.async {
            self.viewController?.displayEmpty(
                viewModel: .init(
                    title: "Что-то пошло не так",
                    icon: UIImage(named: "smile")
                )
            )
        }
    }
    
    func presentCityError() {
        self.viewController?.displayEmpty(
            viewModel: .init(
                title: "Город вылета и город прилета должны быть разными",
                icon: UIImage(named: "smile")
            )
        )
    }
    
    func presentRoute(response: AirportsDataFlow.CheckPlace) {
        viewController?.displayRoute(viewModel: response)
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
