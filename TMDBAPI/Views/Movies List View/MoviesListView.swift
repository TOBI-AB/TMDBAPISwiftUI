//
//  ContentView.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
//import Kingfisher
//import KingfisherSwiftUI


// MARK: - Movies List View
struct MoviesListView: View {
    
    @ObservedObject var fetcher = Fetcher()
    @ObservedObject var movieTypeHandler = MovieTypeHandler.shared
    @State private var moviesIds = [Int]()
    @State private var selection: Int?
    @State private var selectedMovie = Movie.placeholder
    @State private var movieTypePickerSelection = 0

    private let movieTypes: [Endpoint] = [.trending(.movie, .week),.nowPlaying, .popular, .upcoming]
        
    init() {
        self.fetcher.fetchMovies(atEndpoint: .trending(.movie, .week))
    }
    
    // MARK: Main View
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
                .pickerStyle(SegmentedPickerStyle())
                .fixedSize(horizontal: false, vertical: true)
                .padding([.horizontal], 5)
                
                MoviessCollectionView(selectedMovie: self.$selectedMovie, selection: self.$selection)
                    .environmentObject(self.fetcher)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle(Text("Movies"), displayMode: .large)
            .onAppear {
                self.fetcher.movieTypes = self.movieTypes
            }
            .onReceive(self.fetcher.$movies) { (movies) in
                
                let movieIDS = movies.map { $0.id }
                                
                DispatchQueue.global(qos: .background).async {
                    self.fetcher.fetchMoviesDetails(withIDS: movieIDS)
                }
            }
        }
    }
}
