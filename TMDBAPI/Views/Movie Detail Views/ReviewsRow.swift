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
                .lineLimit(4)
                .onTapGesture {
                    self.isReviewContentViewPresented.toggle()
            }
        }.sheet(isPresented: self.$isReviewContentViewPresented) {
            self.modalView
        }
    }
    
    
    fileprivate var modalView: some View {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: true) {
            
                Text(verbatim: self.review.content).padding()
            
            }
            .navigationBarTitle(Text(verbatim: "\(self.review.author.capitalized)"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.isReviewContentViewPresented = false }, label: {
                    Text("Done")
            }))
        }
    }
}

