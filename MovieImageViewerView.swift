//
//  MovieImageViewerView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 23/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct MovieImageViewerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var selectedImage: (UIImage, CGFloat)
   
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }.padding([.top, .trailing])
            }
            Image(uiImage: selectedImage.0)
                .resizable()
                .aspectRatio(selectedImage.1, contentMode: .fit)
                .layoutPriority(1)
            Spacer()
        }.frame(minHeight: 0, maxHeight: .infinity)
    }
}

