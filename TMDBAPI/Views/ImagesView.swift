//
//  ImagesView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 02/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ImagesView: View {
    
    
    @State private var url = [URL]()
    @State private var movieImage = UIImage()
    @State private var isModalShown = false
    @State private var selectedImage = (UIImage(), CGFloat())
    
    let movie: Movie
    var movieImages: [MovieImage]
    
    init(movie: Movie, images: [MovieImage]) {
        self.movie = movie
        self.movieImages = images
    }
    
    var body: some View {
        
        CollectionView(data: self.movieImages)
            .navigationBarTitle(Text("\(self.movie.originalTitle) images"), displayMode: .inline)
            .onReceive(NotificationCenter.default.publisher(for: .DidSelectImage)) { image in
                
                guard let notificationObject = image.object as? (UIImage, CGFloat) else { return }
                
                self.selectedImage = notificationObject
                self.isModalShown.toggle()
                
        }.sheet(isPresented: self.$isModalShown, onDismiss: {
            self.isModalShown = false
        }) {
            ImageViewerView(selectedImage: self.selectedImage)
        }.onDisappear {
            debugPrint(#function)
        }
    }
}

struct ImageViewerView: View {
    
    @Environment(\.presentationMode) var presentationMode

    let selectedImage: (UIImage, CGFloat)
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding([.top, .trailing], 10)
            
            Image(uiImage: selectedImage.0)
                .resizable()
                .aspectRatio(selectedImage.1, contentMode: .fit)
                .padding()
                .layoutPriority(1)
            
            Spacer()
        }
    }
}
