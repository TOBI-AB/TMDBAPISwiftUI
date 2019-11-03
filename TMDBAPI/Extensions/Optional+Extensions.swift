//
//  Optional+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 01/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilAndEmpty: Bool {
        guard let value = self, !value.isEmpty else {
            return true
        }
        return false
    }
}

extension Optional where Wrapped: Collection {
    var isArrayNilAndEmpty: Bool {
        guard let value = self, !value.isEmpty else {
            return true
        }
        return false
    }
}
