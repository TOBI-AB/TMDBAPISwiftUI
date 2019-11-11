//
//  MovieCollectionView.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/15/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
//import Kingfisher
//import KingfisherSwiftUI

struct MovieCollectionView: View {
   
    @ObservedObject var fetcher = Fetcher()
    @State private var movieCollectionDetails = MovieCollectionDetails.placeholder
    
    
    let collection: MovieCollection
    
    init(collection: MovieCollection) {
        self.collection = collection
       // self.fetcher.fetchMovieCollectionDetails(with: self.collection.id)
    }
    
    var body: some View {
        GeometryReader { g in
            ScrollView {
                VStack {
                    // Backdrop
                    ZStack(alignment: .bottomLeading) {
                    
                        ZStack(alignment: .bottom) {
                         /*   KFImage(TMDBAPI.getMoviePosterUrl(self.movieCollectionDetails.posterPath, withSize: "original"))
                                .resizable()
                                .cancelOnDisappear(true)
                                .aspectRatio(3/4, contentMode: .fit)*/
                            
                            LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
                        }
                        
                        Text("\(self.movieCollectionDetails.name)")
                            .bold()
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color(.systemYellow))
                            .padding()
                    }
                    
                    // Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .bold()
                            .font(.headline)
                        Text(self.movieCollectionDetails.overview)
                    }.padding(.horizontal)
                    
                    Divider().padding(.leading)
                    
                    // Movies
                    /*VStack(alignment: .leading, spacing: 8) {
                        Text("Movies")
                            .bold()
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(self.movieCollectionDetails.parts.sorted(by: { $0.releaseDate.toDate < $1.releaseDate.toDate}), id: \.id) { movie in
                                    ColletionMovieRow(movie: movie, proxy: g)
                                }
                            }
                                .padding(.vertical, 5)
                        }
                    }
                    .frame(maxHeight: g.size.height * 0.25)
                    .padding(.horizontal)*/
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitle("\(self.collection.name)")
        .onAppear(perform: {
            self.fetcher.fetchMovieCollectionDetails(with: self.collection.id)
        })
        .onReceive(self.fetcher.$movieCollectionDetails) { (movieCollectionDetails) in
            self.movieCollectionDetails = movieCollectionDetails
        }
    }
    
    struct ColletionMovieRow: View {
        let movie: Movie
        let proxy: GeometryProxy
        @State private var selection: Int?
        var body: some View {
            VStack {
                NavigationLink(destination: MovieDetailsView(title: movie.originalTitle, movieId: movie.id), tag: 0, selection: self.$selection) {
                    EmptyView()
                }
                VStack(spacing: 5) {
                    EmptyView()
                   /* KFImage(TMDBAPI.getMoviePosterUrl(self.movie.posterPath))
                        .resizable()
                        .cancelOnDisappear(true)
                        .frame(width: proxy.size.width / 4)
                        .cornerRadius(8)*/
                    
                    /*Text("\(self.movie.releaseDate.toDate.getComponents([.year]))")
                        .bold()*/
                }.onTapGesture {
                    self.selection = 0
                }
            }
        }
    }
}


