//
//  AirportsListViewController.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

protocol AirportsListViewProtocol {
    func displayAirportList(viewModels: [AirportViewModel])
    func displayEmpty()
    func displayLoading()
}

class AirportsListViewController: UIViewController {
    
    var interactor: AirportsInteractorProtocol?
    
    private var tableView: UITableView!
    private var airportsList: [AirportViewModel] = []
    private let placeholderView: PlaceholderView = PlaceholderView()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup

private extension AirportsListViewController {
    
    struct Utility {
        static let cellHeight: CGFloat = 56
        static let headerHeight: CGFloat = 52
        static let startPlaceholderIcon: UIImage? = UIImage(named: "airplane")
        static let notFoundPlaceholderIcon: UIImage? = UIImage(named: "smile")
        static let startTitle: String = "Начните поиск"
        static let notFoundTitle: String = "Не нашли"
    }
    
    func setup() {
        setupTableView()
        placeholderView.configure(
            title: Utility.startTitle,
            icon: Utility.startPlaceholderIcon
        )
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
    
    func displayEmpty() {
        activityIndicator.stopAnimating()
        placeholderView.isHidden = false
        airportsList.removeAll()
        tableView.reloadData()
        placeholderView.configure(
            title:Utility.notFoundTitle,
            icon: Utility.notFoundPlaceholderIcon
        )
    }
    
    func displayLoading() {
        airportsList.removeAll()
        tableView.reloadData()
        activityIndicator.startAnimating()
        placeholderView.isHidden = true
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
        Utility.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = AirportHeaderView()
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Utility.headerHeight
    }
}
