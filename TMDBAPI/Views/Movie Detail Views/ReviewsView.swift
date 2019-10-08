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
        ScrollView {
            VStack {
                ForEach(self.reviews, id: \.id) { review in
                    ReviewsRow(review: review)
                }
            }.background(Color.purple)
        }
        .navigationBarTitle(Text("Reviews"), displayMode: .inline)
        
    }
}

struct ReviewsRow: View {
    
    let review: Review
    
    @State private var isOverviewCollapsed = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: review.author.capitalized)
                .font(.headline).background(Color.orange)
            
            Text(verbatim: review.content).background(Color.green)
            .lineLimit(4)
           // .lineLimit(4)//(isOverviewCollapsed ? 6 : nil)
              //  .animation(.spring())
            
            /*HStack {
                Spacer()
                Button(action: { self.isOverviewCollapsed.toggle() }) {
                    Text(review.content.linesNumber > 6 ? "more" : "less")
                }
                .foregroundColor(Color(.systemBlue))
            }*/
        }
    }
}
