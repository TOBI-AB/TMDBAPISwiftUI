//
//  MovieImagesView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 23/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Kingfisher
import KingfisherSwiftUI

struct MovieImagesView: View {
    
    let data: [MovieImage]
    @State private var selection: Int?
     @State private var selectedImage = (UIImage(), CGFloat())
    
    var body: some View {
        HStack {
            ForEach(data, id: \.self) {movieImage in
                MovieImageView(movieImage: movieImage)
            }
        }.padding(.vertical, 5)
    }
    
    struct MovieImageView: View {
        let movieImage: MovieImage

        var body: some View {
            KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(movieImage.filePath)!,
                                                   cacheKey: movieImage.filePath)))
                .resizable()
                .aspectRatio(CGFloat(movieImage.aspectRatio), contentMode: .fit)
                .onTapGesture {
                    ImageCache.default.notifyImageSelection(for: self.movieImage,
                                                            notificationName: .imagesSectionDidSelectedImage)
			}.cornerRadius(10)
        }
    }
}
