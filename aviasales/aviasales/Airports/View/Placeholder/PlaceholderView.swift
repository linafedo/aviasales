//
//  PlaceholderView.swift
//  aviasales
//
//  Created by Galina Fedorova on 11.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {
    
    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    
    init() {
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

// MARK: - setup

private extension PlaceholderView {
    
    struct Utility {
        static let iconHeight: CGFloat = 100
        static let titleBottomConst: CGFloat = 32
    }

    func setup() {
        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(
            equalTo: centerYAnchor
        ).isActive = true
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: Utility.iconHeight).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: Utility.iconHeight).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(
            equalTo: iconView.bottomAnchor,
            constant: Utility.titleBottomConst
        ).isActive = true
        
        
        titleLabel.textColor = .lightGray
    }
}
