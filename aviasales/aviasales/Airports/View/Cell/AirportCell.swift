//
//  AirportCell.swift
//  aviasales
//
//  Created by Galina Fedorova on 11.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

class AirportCell: UITableViewCell {
    
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let sideLabel: UILabel = UILabel()
    private let verticalStack: UIStackView = UIStackView()
    private let horizontalStack: UIStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: AirportViewModel) {
        if viewModel.airportName == nil {
            titleLabel.text = viewModel.name
            descriptionLabel.isHidden = true
        } else {
            titleLabel.text = viewModel.airportName
            descriptionLabel.text = viewModel.name
            descriptionLabel.isHidden = false
        }
        sideLabel.text = viewModel.iata
    }
}

// MARK: - setup

private extension AirportCell {

    struct Utility {
        static let verticalInset: CGFloat = 4
        static let leadingConst: CGFloat = 16
    }
    
    func setup() {
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = .systemFont(ofSize: 14)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(descriptionLabel)
        verticalStack.axis = .vertical
        verticalStack.spacing = Utility.verticalInset
        
        horizontalStack.addArrangedSubview(verticalStack)
        horizontalStack.addArrangedSubview(UIView())
        horizontalStack.addArrangedSubview(sideLabel)

        addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: Utility.leadingConst
        ).isActive = true
        horizontalStack.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -Utility.leadingConst
        ).isActive = true
        horizontalStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
