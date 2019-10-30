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
    @ObservedObject var movieTypeHandler = MovieTypeHandler.shared
    @State private var moviesIds = [Int]()
    @State private var selection: Int?
    @State private var selectedMovie = Movie.placeholder
    @State private var movieTypePickerSelection = 0

    private let movieTypes: [Endpoint] = [.nowPlaying, .popular, .topRated, .upcoming]
        
    init() {
        self.fetcher.fetchMovies(atEndpoint: .nowPlaying)
    }
    
    // MARK: Main View
    @ViewBuilder
    var body: some View {
       
        NavigationView {
          
            VStack {
                NavigationLink(destination: MovieDetailsView(movieId: self.selectedMovie.id).environmentObject(self.fetcher), tag: 0, selection: self.$selection) {
                    EmptyView()
                }
                
                Picker(selection: self.$fetcher.movieType, label: Text("")) {
                    ForEach(0..<self.movieTypes.map({$0.stringValue}).count) {
                        Text(self.movieTypes.map({$0.stringValue})[$0])
                            .tag($0)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .pickerStyle(SegmentedPickerStyle())
                .padding([.horizontal],5)
                
                MoviessCollectionView(selectedMovie: self.$selectedMovie, selection: self.$selection)
                    .environmentObject(self.fetcher)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle(Text("Movies"), displayMode: .large)
            .onReceive(self.fetcher.$movies) { (movies) in
                
                let movieIDS = movies.map { $0.id }
                                
                DispatchQueue.global(qos: .background).async {
                    self.fetcher.fetchMoviesDetails(withIDS: movieIDS)
                }
            }
        }
    }
    
}

// MARK: - Movie Row
struct MovieRow: View {
    
    @State private var imageSize: CGSize = .zero
    
    let movie: Movie
    let size: CGSize
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            // MARK: Movie Poster
            KFImage(source: TMDBAPI.imageResource(for: movie.posterPath))//, options: [.transition(.fade(0.5))])
                .resizable()
                .renderingMode(.original)
                .aspectRatio(0.7, contentMode: .fit)
                .frame(width: (size.width - 48) / 2)
                .cornerRadius(5)
                .shadow(radius: 10).layoutPriority(1)
            
            // MARK: Movie Title
            /*VStack(alignment: .leading, spacing: 10) {
             
             Text(movie.originalTitle).font(.headline).truncationMode(.tail)//.lineLimit(2)//.frame(maxWidth: .infinity)
             
             if movie.originalTitle != movie.title {
             Text(movie.title) .font(.headline)
             }
             
             //Spacer()
             }*/
            
            
        }.background(Color.blue.opacity(0.6))
    }
}
