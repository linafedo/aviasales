//
//  PlaceholderView.swift
//  aviasales
//
//  Created by Galina Fedorova on 11.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

final class PlaceholderView: UIView {
    
    private let appearance: Appearance
    private let iconView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, icon: UIImage?) {
        titleLabel.text = title
        iconView.image = icon
    }
}

// MARK: -  Appearance
extension PlaceholderView {
    struct Appearance {
        let iconHeight: CGFloat = 100
        let titleBottomConst: CGFloat = 32
        let labelOffset: CGFloat = 36
        let topOffset: CGFloat = 100
    }
}

// MARK: - setup

private extension PlaceholderView {

    func setup() {
        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(
            equalTo: topAnchor,
            constant: appearance.topOffset
        ).isActive = true
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: appearance.iconHeight).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: appearance.iconHeight).isActive = true

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: appearance.titleBottomConst
        ).isActive = true
        titleLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -appearance.titleBottomConst
        ).isActive = true
        titleLabel.topAnchor.constraint(
            equalTo: iconView.bottomAnchor,
            constant: appearance.titleBottomConst
        ).isActive = true
        
        titleLabel.textColor = .lightGray
    }
}
