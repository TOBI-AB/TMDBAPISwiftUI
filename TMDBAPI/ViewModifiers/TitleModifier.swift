//
//  titleModifier.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 31/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI


struct TitleModifier: ViewModifier {
   
    func body(content: Content) -> some View {
        content
            .font(.system(.title, design: .rounded))
            .foregroundColor(.white)
            .lineLimit(4)
    }
}
