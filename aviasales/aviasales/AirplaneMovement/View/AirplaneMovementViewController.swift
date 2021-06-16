//
//  AirplaneMovementViewController.swift
//  aviasales
//
//  Created by Galina Fedorova on 12.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

protocol AirplaneMovementViewProtocol: AnyObject {
    func displayInitialState(viewModel: AirplaneMovementViewModel)
}

class AirplaneMovementViewController: UIViewController {
    
    private var interactor: AirplaneMovementInteractorProtocol?
    private var viewModel: AirplaneMovementLocationViewModel?
    
    private let mapView: MapViewProtocol = GoogleMapView()
    
    init(interactor: AirplaneMovementInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInitialState()
    }
    
    deinit {
        mapView.reset()
    }
}

// MARK: - AirplaneMovementViewProtocol

extension AirplaneMovementViewController: AirplaneMovementViewProtocol {
    
    func displayInitialState(viewModel: AirplaneMovementViewModel) {
        mapView.configure(with:
            .init(
                fromLocation: .init(
                    iata: viewModel.fromLocation.iata,
                    latitude: viewModel.fromLocation.latitude,
                    longitude: viewModel.fromLocation.longitude),
                toLocation: .init(
                    iata: viewModel.toLocation.iata,
                    latitude: viewModel.toLocation.latitude,
                    longitude: viewModel.toLocation.longitude)
                )
        )
    }
}

// MARK: - private

extension AirplaneMovementViewController {
    
    func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupInitialState() {
        interactor?.loadInitialState()
    }
}

