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
    
    var body: some View {
        HStack {
            ForEach(data, id: \.self) {movieImage in
                MovieImageView(movieImage: movieImage)
            }
        }
    }
    
    struct MovieImageView: View {
        let movieImage: MovieImage

        var body: some View {
            KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(movieImage.filePath)!,
                                                   cacheKey: movieImage.filePath)))
            .resizable()
            .scaledToFit()//aspectRatio(CGFloat(movieImage.aspectRatio), contentMode: .fit)
            .onTapGesture {
                ImageCache.default.getImage(for: self.movieImage)
            }
        }
    }
}
