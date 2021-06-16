//
//  AirportsListViewController.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

protocol AirportsListViewProtocol: AnyObject {
    func displayAirportList(viewModels: [AirportViewModel])
    func displayEmpty(viewModel: AirportsDataFlow.Placeholder.ViewModel)
    func displayLoading()
    func displayInitialState(viewModel: AirportsDataFlow.InitialState.ViewModel)
    func displayRoute(viewModel: AirportsDataFlow.CheckPlace)
}

class AirportsListViewController: UIViewController {
    
    private var interactor: AirportsInteractorProtocol?
    private var airportsList: [AirportViewModel] = []
    
    private let appearance: Appearance
    
    private var tableView: UITableView!
    private let placeholderView: PlaceholderView = PlaceholderView()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var headerView: AirportHeaderView = AirportHeaderView()
    
    init(
        appearance: Appearance = Appearance(),
        interactor: AirportsInteractorProtocol
    ) {
        self.appearance = appearance
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setupInitialState()
    }
}

// MARK: - Appearance

extension AirportsListViewController {
    struct Appearance {
        let cellHeight: CGFloat = 56
        let headerHeight: CGFloat = 52
    }
}

// MARK: - Setup

private extension AirportsListViewController {
    
    func setup() {
        setupTableView()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(AirportCell.self, forCellReuseIdentifier: "AirportCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.backgroundView = placeholderView
        
        headerView.delegate = self
    }
}

// MARK: - AirportsListViewProtocol

extension AirportsListViewController: AirportsListViewProtocol {
   
    func displayAirportList(viewModels: [AirportViewModel]) {
        activityIndicator.stopAnimating()
        airportsList = viewModels
        tableView.reloadData()
        placeholderView.isHidden = true
    }
    
    func displayEmpty(viewModel: AirportsDataFlow.Placeholder.ViewModel) {
        activityIndicator.stopAnimating()
        placeholderView.isHidden = false
        airportsList.removeAll()
        tableView.reloadData()
        placeholderView.configure(
            title: viewModel.title,
            icon: viewModel.icon
        )
    }
    
    func displayLoading() {
        airportsList.removeAll()
        tableView.reloadData()
        activityIndicator.startAnimating()
        placeholderView.isHidden = true
    }
    
    func displayInitialState(viewModel: AirportsDataFlow.InitialState.ViewModel) {
        setup()
        title = viewModel.cityName
        placeholderView.configure(
            title: viewModel.title,
            icon: viewModel.icon
        )
    }
    
    func displayRoute(viewModel: AirportsDataFlow.CheckPlace) {
        let vc = AirplaneMovementFactory().build(
            toLatitude: viewModel.latitude,
            toLongitude: viewModel.longitude,
            iata: viewModel.iata
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - SearchDelegate

extension AirportsListViewController: SearchDelegate {
    func search(for city: String) {
        interactor?.fetchAirportList(request: .init(city: city))
    }
}

// MARK: - TableView data source and delegate

extension AirportsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airportsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirportCell", for: indexPath) as! AirportCell
        cell.configure(viewModel: airportsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        appearance.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        appearance.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let model = airportsList[indexPath.row]
        interactor?.checkPlace(
            request: .init(
                latitude: model.latitude,
                longitude: model.longitude,
                name: model.name,
                iata: model.iata
            )
        )
    }
}
