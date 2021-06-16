//
//  ArrayExtensions.swift
//  aviasales
//
//  Created by Galina Fedorova on 16.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
