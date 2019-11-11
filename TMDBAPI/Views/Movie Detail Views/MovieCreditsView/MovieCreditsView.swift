//
//  MovieCreditsView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine
import KingfisherSwiftUI
import class Kingfisher.ImageCache

// MARK: - Movie Credits View
struct MovieCreditsView: View {
	        
    let credits: [GenericCodable]
    let size: CGSize
    
    @State private var fetcher = Fetcher()
    @State private var person = Person.placeholder
    @State private var selection: Int?
    

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(self.credits, id:\.identifier) { credit in
                    RowView(genericType: credit)
                        .frame(width: self.size.width / 4, height: (self.size.width / 4) / 0.7)
                }
            }
        }
    }
}


struct RowView: View {
    
    let genericType: GenericCodable
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack {
                KFImage(source: TMDBAPI.imageResource(for: self.genericType.typeProfileImageUrl))
                    .resizable()
                    .cancelOnDisappear(true)
                    .clipped()
                    .border(Color(.systemBackground))
                
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center,  endPoint: .bottom)
                
            }
            
            VStack {
                Text(self.genericType.typeTitle)
                    .bold()
                    .font(.system(size: 13))
                    
                    .lineLimit(self.genericType.type == .movie ? 2 : 1)
                                    
                if !self.genericType.typeExtraInfo.isEmpty {
                    Text(self.genericType.typeExtraInfo)
                        .font(.system(size: 12))
                        .lineLimit(self.genericType.type == .movie ? 1 : 2)
                }
            }
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(5)
        }
        .cornerRadius(10)
    }
}
