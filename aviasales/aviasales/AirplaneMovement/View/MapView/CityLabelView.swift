//
//  CityLabelView.swift
//  aviasales
//
//  Created by Galina Fedorova on 15.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

final class CityLabelView: UIView {
    
    private let titleLabel: UILabel = UILabel()
    private let appearance: Appearence
    
    init(title: String, appearance: Appearence = Appearence()) {
        self.appearance = appearance
        super.init(frame: .init(origin: .zero, size: appearance.size))
        setup()
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

extension CityLabelView {
    struct Appearence {
        let size: CGSize = .init(width: 60, height: 28)
        let alpha: CGFloat = 0.7
        let borderWidth: CGFloat = 2
    }
}

// MARK: - Setup

private extension CityLabelView {
    func setup() {
        backgroundColor = UIColor.white.withAlphaComponent(appearance.alpha)
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = appearance.borderWidth

        addSubview(titleLabel)
        titleLabel.textColor = .blue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
