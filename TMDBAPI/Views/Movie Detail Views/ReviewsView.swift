//
//  ReviewsView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct ReviewsView: View {
    
    let reviews: [Review]
    
    var body: some View {
        List {
            ForEach(reviews, id: \.id) { review in
                ReviewsRow(review: review)
            }
        }
        .navigationBarTitle(Text("Reviews"), displayMode: .large)
    }
}

struct ReviewsRow: View {
    
    let review: Review
    
    @State private var isOverviewCollapsed = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: review.author)
                .font(.headline)
            
            Text(verbatim: review.content)
                .layoutPriority(1)
                .lineLimit(isOverviewCollapsed ? 6 : nil)
                .animation(.spring())
            
            HStack {
                Spacer()
                Button(action: { self.isOverviewCollapsed.toggle() }) {
                    Text(review.content.linesNumber > 6 ? "more" : "less")
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
    }
}
