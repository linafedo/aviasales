//
//  AirportHeaderView.swift
//  aviasales
//
//  Created by Galina Fedorova on 11.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

protocol SearchDelegate: AnyObject {
    func search(for city: String)
}

class AirportHeaderView: UIView {
    
    private let searchBar: UISearchBar = UISearchBar()
    weak var delegate: SearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setup

private extension AirportHeaderView {
    
    func setupSearchBar() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        searchBar.delegate = self
    }
}

extension AirportHeaderView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.search(for: searchText)
    }
}
