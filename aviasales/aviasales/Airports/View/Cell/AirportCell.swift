//
//  AirportCell.swift
//  aviasales
//
//  Created by Galina Fedorova on 11.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

class AirportCell: UITableViewCell {
    
    private let appearance: Appearance = Appearance()
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

// MARK: - Appearance

extension AirportCell {
    struct Appearance {
        let verticalInset: CGFloat = 4
        let leadingConst: CGFloat = 16
        let systemFont: CGFloat = 14
    }
}

// MARK: - setup

private extension AirportCell {

    func setup() {
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = .systemFont(ofSize: appearance.systemFont)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(descriptionLabel)
        verticalStack.axis = .vertical
        verticalStack.spacing = appearance.verticalInset
        
        horizontalStack.addArrangedSubview(verticalStack)
        horizontalStack.addArrangedSubview(UIView())
        horizontalStack.addArrangedSubview(sideLabel)

        addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: appearance.leadingConst
        ).isActive = true
        horizontalStack.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -appearance.leadingConst
        ).isActive = true
        horizontalStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
