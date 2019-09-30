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

struct CompanyImageModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(width: 80, height: 100)
            .padding(2)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1).opacity(0.5))
    }
}

struct CreditImageModifier: ViewModifier {
	func body(content: Content) -> some View {
        content
            .frame(width: 80, height: 80, alignment: .center)
			.aspectRatio(contentMode: .fit)
			.clipShape(Circle())
			.padding(2)
			.overlay(Circle().strokeBorder(Color(.systemGray).opacity(0.6), lineWidth: 5, antialiased: true))
			.layoutPriority(1)
    }
}
