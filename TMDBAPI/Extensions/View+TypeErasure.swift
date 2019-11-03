//
//  View+TypeErasure.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 11/2/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
