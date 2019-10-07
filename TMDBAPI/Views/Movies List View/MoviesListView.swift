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


// MARK: - Movies List View
struct MoviesListView: View {
    
    @ObservedObject var fetcher = Fetcher()
    @State private var movieDetailsNavigationLink: Int?
    
    init() {
         self.fetcher.fetchMovies()
    }
    
    // MARK: Main View
    var body: some View {
        GeometryReader { g in
            NavigationView {
                List {
                    ForEach(self.fetcher.movies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailsView(movieId: movie.id).environmentObject(self.fetcher)) {
                            MovieRow(movie: movie, proxy: g)
                        }
                    }
                }
                .navigationBarTitle(Text("Movies"))
                .onReceive(self.fetcher.$movies) { (movies) in
                    let movieIDS = movies.map { $0.id }
                    self.fetcher.fetchMoviesDetails(withIDS: movieIDS)
                }
            }
        }
    }
}

// MARK: - Movie Row
struct MovieRow: View {
    
   // @ObservedObject var fetcher = Fetcher()
    @State private var imageSize: CGSize = .zero
    
  //  @Binding var movieDetailsNavigationLink: Int?
    let movie: Movie
    let proxy: GeometryProxy
    
    var body: some View {

        HStack(alignment: .top, spacing: 10) {
            
            // MARK: Movie Poster
            KFImage(source: TMDBAPI.imageResource(for: movie.posterPath), options: [.transition(.fade(0.5))])
                .resizable()
                .aspectRatio(0.7, contentMode: .fit)
                .frame(width: proxy.frame(in: .global).size.width / 4)
                .cornerRadius(10)
                .shadow(radius: 10)
    
            // MARK: Movie Title
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.originalTitle)//.frame(maxWidth: .infinity)
                if movie.originalTitle != movie.title {
                    Text(movie.title)
                }
            }
            .font(.headline)
        }
        .padding(.vertical,8)
       
    }
}
