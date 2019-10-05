//
//  ContentView.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Kingfisher
import KingfisherSwiftUI

struct MoviesListView: View {
    
    @ObservedObject var fetcher = Fetcher()
    
    @State private var movies = [Movie]()
    @State private var moviePoster = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(movies, id: \.id) { movie in
					NavigationLink(destination: DetailView(movie: movie)) {
                        MovieRow(movie: movie)
                    }
                }
            }
            .navigationBarTitle(Text("Movies"))
        }
		.onAppear(perform: {
			self.fetcher.fetchMovies()
		})
		.onDisappear {
			self.fetcher.cancel()
		}
        .onReceive(self.fetcher.$movies) { (movies) in
            DispatchQueue.main.async {
                self.movies = movies
            }
        }
		
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		MoviesListView()
    }
}

struct MovieRow: View {
    
    let movie: Movie
    
    var posterPath: String {
        movie.posterPath ?? ""
    }
    
    lazy var source: ImageResource = {
        ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(posterPath)!, cacheKey: posterPath)
    }()
    

    @ViewBuilder
    var body: some View {

        HStack(alignment: .top, spacing: 10) {

            if TMDBAPI.getMoviePosterUrl(posterPath) != nil {
                                            
              KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(self.posterPath)!,
                                                     cacheKey: posterPath)),options: [.transition(.fade(0.4))])
                .resizable()
                .placeholder {
                    HStack {
                        Image(systemName: "arrow.2.circlepath.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding(40)
                    }
                    .foregroundColor(.gray)
                    .opacity(0.3)
                }
                .frame(width: 80, height: 100)
                .cornerRadius(8)
                .shadow(radius: 8)
            }
    
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.originalTitle)
                if movie.originalTitle != movie.title {
                    Text(movie.title)
                }
            }
            .font(.headline)
        }.padding(.vertical,8)
        
    }
    
    
    var movieImage: some View {
        KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(self.posterPath)!, cacheKey: posterPath)), options: [.transition(.fade(0.4))])
    }
}
