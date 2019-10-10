//
//  ReviewsRow.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/8/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct ReviewsRow: View {
    
    let review: Review
    
    @State private var isReviewContentViewPresented = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
        
            Text(verbatim: review.author.capitalized)
                .font(.headline)
            Text(verbatim: review.content)
                .lineLimit(self.review.content.paragraphs.count == 1 ? nil : 4)
                .layoutPriority(1)
                .onTapGesture {
                    if self.review.content.paragraphs.count > 1 {
                        self.isReviewContentViewPresented.toggle()
                    }
            }
        }.sheet(isPresented: self.$isReviewContentViewPresented) {
            ContentModalView(title: self.review.author,
                             content: self.review.content,
                             isContentViewPresented: self.$isReviewContentViewPresented)
        }
    }
}

