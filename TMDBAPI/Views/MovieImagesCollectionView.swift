//
//  ImagesView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 02/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct MovieImagesCollectionView: View {
    
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
            }
            .sheet(isPresented: self.$isModalShown, onDismiss: {
                self.isModalShown = false
            }) {
                MovieImageViewerView(selectedImage: self.selectedImage)
            }
    }
}


