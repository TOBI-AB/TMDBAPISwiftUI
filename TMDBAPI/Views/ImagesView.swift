//
//  ImagesView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 02/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import QGrid

struct ImagesView: View {
    
    @ObservedObject var fetcher = Fetcher()
    @State private var url = [URL]()
    @State private var images = [MovieImage]()
    @State private var aspectRatio: CGFloat = 0.0
    @State private var movieImage = UIImage()
    @State private var isModalShown = false
    
    let movie: Movie
    var movieImages: [MovieImage]
    init(movie: Movie, images: [MovieImage]) {
        self.movie = movie
        self.movieImages = images
        //self.fetcher.fetchMovieImages(movie)
    }
    
    var body: some View {
        
        QGrid(self.movieImages, columns: 3) {
            KFImage(TMDBAPI.getMoviePosterUrl($0.filePath)!)
                .resizable()
                .scaledToFit()
                .onTapGesture { self.isModalShown.toggle() }
        }
        .navigationBarTitle(Text("\(self.movie.originalTitle) images"), displayMode: .inline)
        /*.onReceive(self.fetcher.$images) { (images) in
            DispatchQueue.main.async {
                self.images = images
            }
        }*/
        .sheet(isPresented: $isModalShown, onDismiss: {
            self.isModalShown.toggle()
        }) {
            ImageViewerView(image: self.movieImage)
        }
    }
}

struct ImageViewerView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
        .resizable()
        .scaledToFit()
            .onDisappear { self.presentationMode.wrappedValue.dismiss() }
    }
}
