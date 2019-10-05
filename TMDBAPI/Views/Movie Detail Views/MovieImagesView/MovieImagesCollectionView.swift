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
    @State private var selectedImage = (UIImage(), CGFloat())
    @State private var selection: Int?
    @State private var isModalShown = false
    
    let movie: Movie
    var movieImages: [MovieImage]
    
    init(movie: Movie, images: [MovieImage]) {
        self.movie = movie
        self.movieImages = images
    }
    
    var body: some View {
        CollectionView(data: self.movieImages)
            .navigationBarTitle(Text("\(self.movie.originalTitle) images"), displayMode: .inline)
            .onReceive(NotificationCenter.default.publisher(for: .collectionViewDidSelectedImage)) { image in
                guard let notificationObject = image.object as? (UIImage, CGFloat) else { return }
                
                self.selectedImage = notificationObject
                self.selection = 3
                self.isModalShown.toggle()
		}
        .sheet(isPresented: self.$isModalShown) {
            MovieImageViewerView(selectedImage: self.selectedImage)
        }
    }
}


