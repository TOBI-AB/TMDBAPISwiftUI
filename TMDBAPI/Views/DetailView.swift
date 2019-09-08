//
//  DetailView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 29/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine
import KingfisherSwiftUI

struct DetailView: View {
    
    @ObservedObject var fetcher = Fetcher()
    @State private var _movie = Movie.placeholder
    @State private var moviePosterPath = ""
    @State private var genres = [Genre]()
    @State private var reviews = [Review]()
    @State var coverImageHeight: CGFloat = 0.0
    @State var budget: Double = 0.0
    @State var revenue: Double = 0.0
    @State var productionCompanies: [ProductionCompany] = []
    @State var productionCountries: [ProductionCountry] = []
    @State var images = [MovieImage]()
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        self.fetcher.fetchMovieDetails(movie)
        self.fetcher.fetchMovieReviews(movie)
        
    }
    
    var topSection: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack {
                KFImage(TMDBAPI.getMoviePosterUrl(self.moviePosterPath)!)
                    .resizable()
                    .cancelOnDisappear(true)
                //Color.white
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
               /* .mask(
                    KFImage(TMDBAPI.getMoviePosterUrl(self.moviePosterPath)!)
                        .resizable()
                        .cancelOnDisappear(true)
                )*/
            }
            self.detailsView
        }.listRowInsets(EdgeInsets.zero)
    }
    //.cornerRadius(20)
    var body: some View {
        GeometryReader { g in
            List {
                self.topSection
                        .frame(height: g.size.height * 0.9)
                self.ratingView
                self.overviewView
              
                Section(header: Text("Extra Details").bold()) {
                    self.extraDetailsView.environment(\.lineSpacing, 5)
                }
                
                Section(header: Text("Images & Videos").bold()) {
                    self.imagesView
                }
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .onReceive(self.fetcher.$movieDetails) { (movie) in
            DispatchQueue.main.async {
                self.setupWithMovie(movie)
            }
        }
    }
}


// MARK: - ROWS ViEW
extension DetailView {
    
    // MARK: Movie Poster
    var detailsView: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            titleView.font(.body)
            
            genresView
            
            HStack {
                Text(verbatim: _movie.releaseDate)
                if _movie.runtime != nil {
                    Text("•").font(.headline).foregroundColor(Color(.systemYellow))
                    Text(_movie.runtime!.toTime)
                }
            }.foregroundColor(.white)
                        
            if !_movie._videos.isEmpty {
                trailerButton
            }
       
        }.padding()
    }
    
    // MARK: Title View
    var titleView: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(_movie.originalTitle.uppercased())
                .bold()
                .modifier(TitleModifier())
            
            if _movie.originalTitle != _movie.title {
                Text(_movie.title)
                    .bold()
                    .modifier(TitleModifier())
            }
        }
    }
    
    // MARK: Genres View
    var genresView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres.map { $0.name }, id: \.self) { genreName in
                    Text(genreName)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.white)
                        .padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(.systemYellow)))//.opacity(0.7))
                }
            }
            .padding([.leading,.vertical],5)
        }
        .padding(.leading, -5)
       // .padding(.trailing, -20)
    }
    
    // MARK: Rating View
    var ratingView: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 10) {
                Text("RATING")
                    .font(.subheadline)
                Text(verbatim: "\(_movie.voteAverage)")
                    .font(.headline)
            }
            Divider()
            VStack(alignment: .center, spacing: 10) {
                Text("VOTES")
                    .font(.subheadline)
                Text(verbatim: "\(_movie.voteCount)")
                    .font(.headline)
            }
            Divider()
            VStack(alignment: .center, spacing: 10) {
                Text("POPULARITY")
                    .font(.subheadline)
                Text(verbatim: "\(_movie.popularity)")
                    .font(.headline)
            }
        }
        .frame(maxWidth:.infinity)
        .padding(.vertical, 5)
    }
    
    // MARK: Trailer Button
    var trailerButton: some View {
        Button(action: { self.playTrailer() }) {
            HStack(spacing: 5) {
                Image(systemName: "play").imageScale(.small)
                Text("TRAILER").font(.subheadline)
            }.foregroundColor(.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).padding(.vertical, 5)
        }
        .padding(.horizontal)
        .background(Color.init(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemYellow)))//.opacity(0.7))
    }
    
    // MARK: Overview
    var overviewView: some View {
        Text("\(_movie.overview)")
            .padding(.vertical, 10)
    }
    
    // MARK: Extra Details
    var extraDetailsView: some View {
        Group {
            Group {
                Text("Spoken Languages:\n").bold() + Text(_movie.languages)
                Text("Budget: ").bold() + Text("\(self.budget.toCurrency ?? "")")
                Text("Revenue: ").bold() + Text("\(self.revenue.toCurrency ?? "")")
            }
           
            Group {
                NavigationLink(destination: ProductionCompaniesView(productionCompanies: productionCompanies)) {
                    Text("Production Companies:\n").bold()
                        +
                    Text("\(self.productionCompanies.compactMap { "\($0.name)" }.joined(separator: "\n"))")
                }
                
                Text("Production Countries:\n").bold()
                    +
                Text("\(self.productionCountries.compactMap {$0.name}.joined(separator: "\n"))")
            }
        }
    }
    
    @ViewBuilder
    var imagesView: some View {
        if _movie.imagesUrls.count <= 3 {
            ForEach(_movie.imagesUrls[0..<_movie.imagesUrls.count], id: \.self) {url in
                HStack {
                    KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight:40, maxHeight: 120)
                }
            }
        } else {
            NavigationLink(destination: ImagesView(movie: _movie, images: self.images)) {
                Text("\(_movie.imagesUrls.count) ").bold() + Text("Images")
            }
        }
    }
    
}

// MARK: - HELPERS
extension DetailView {
    fileprivate func setupWithMovie(_ movie: Movie) {
        self._movie = movie
        
        if let posterPath = movie.posterPath {
            self.moviePosterPath = posterPath
        }
        
        if let unwrappedGenres = movie.genres {
            self.genres = unwrappedGenres
        }
        
        if let unwrappedBudget = movie.budget {
            self.budget = unwrappedBudget
        }
        if let unwrappedRevenue = movie.revenue {
            self.revenue = unwrappedRevenue
        }
        
        if let unwrappedProductionCompanies = movie.productionCompanies {
            self.productionCompanies = unwrappedProductionCompanies
        }
        
        if let unwrappedProductionCountries = movie.productionCountries {
            self.productionCountries = unwrappedProductionCountries
        }
        
        if let unwrappedImages = movie.images {

            self.images = unwrappedImages.posters//.compactMap { TMDBAPI.getMoviePosterUrl($0.filePath) }
            
        }
    }
    
    fileprivate func playTrailer() {
        
        var trailerKey = ""
        
        guard let unwrappedVideos = _movie.videos else { return }
        
        let trailers = unwrappedVideos.results.filter { $0.type == "Trailer" }.sorted { $0.size > $1.size }
        
        trailerKey = (trailers.isEmpty) ? unwrappedVideos.results.sorted { $0.size > $1.size }[0].key : trailers[0].key
        
        guard let trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)") else { return }
        
        if UIApplication.shared.canOpenURL(trailerUrl) {
            UIApplication.shared.open(trailerUrl, options: [: ])
        }
    }
}

extension DetailView {
    var detailsSectionHeader: some View {
        Text("Details").bold().background(Color.white).frame(maxWidth: .infinity)
    }
}

