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
    @State private var reviewSentencesCount: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(self.review.author.capitalized)
                .font(.headline)
            
            Text(self.review.content.trimmingCharacters(in: .init(["*","_"])))
                .frame(maxWidth: .infinity)
                .lineLimit(reviewSentencesCount)
            }
        .padding(5)
        .cornerRadius(8)
        .onAppear {
            self.reviewSentencesCount = (self.review.content.sentences.count <= 6) ? nil : 4
        }
        .onTapGesture {
            self.isReviewContentViewPresented.toggle() //(self.review.content.sentences.count <= 6) ? false : true
        }
        .sheet(isPresented: self.$isReviewContentViewPresented) {
            ContentModalView(title: self.review.author,
                             content: self.review.content,
                             isContentViewPresented: self.$isReviewContentViewPresented)
        }
    }
}

