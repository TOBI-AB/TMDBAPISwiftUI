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
          //  ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(self.reviews, id: \.id) { review in
                        VStack {
                            ReviewsRow(review: review)
                            if self.reviews.indexOfElement(review) < self.reviews.count {
                                Divider()
                            }
                        }
                    }
                }
          //  }
            .navigationBarTitle(Text("Reviews"), displayMode: .large)
        
    }
}

struct ReviewsRow: View {
    
    let review: Review
    
    @State private var isOverviewCollapsed = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: review.author.capitalized)
                .font(.headline)
            
            Text(verbatim: review.content)
              //  .layoutPriority(1)
                .lineLimit(4)//(isOverviewCollapsed ? 6 : nil)
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
