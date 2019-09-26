//
//  DetailView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 29/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine
import Kingfisher
import KingfisherSwiftUI

// MARK: - Main View
struct DetailView: View {
    
    // MARK: Properties
    @ObservedObject var fetcher = Fetcher()
    
    @State private var _movie = Movie.placeholder
    @State private var moviePosterPath = ""
    @State private var genres = [Genre]()
    @State private var reviews = [Review]()
    @State private var budget: Double = 0.0
    @State private var revenue: Double = 0.0
    @State private var productionCompanies = [ProductionCompany]()
    @State private var productionCountries = [ProductionCountry]()
    @State private var movieImages = [MovieImage]()
    @State private var movieImagesCounting = false
    @State private var imageLinkSelection: Int? = nil
    @State private var productionCompanyLinkSelection: Int? = nil
    @State private var isModalShown = false
    @State private var selectedImage = (UIImage(), CGFloat())

    
    let movie: Movie
    
    // MARK: Initialization
    init(movie: Movie) {
        self.movie = movie
        self.fetcher.fetchMovieDetails(movie)
        self.fetcher.fetchMovieReviews(movie)
    }
    
    // MARK: Views
    var topSection: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack {
                KFImage(TMDBAPI.getMoviePosterUrl(self.moviePosterPath)!)
                    .resizable()
                    .cancelOnDisappear(true)
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
            }
            self.detailsView
        }.listRowInsets(EdgeInsets.zero)
    }
    
    var body: some View {
        GeometryReader { g in
            List {
                self.topSection
                    .frame(height: g.frame(in: .global).size.height * 0.9)
                self.ratingView
                self.overviewView

                Section {
                    self.extraDetailsView.environment(\.lineSpacing, 5)
                }
 
                Section(header: self.ImagesViewSectionHeader) {
                    self.movieImagesView
                }
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .onReceive(self.fetcher.$movieDetails) { (movie) in
            DispatchQueue.main.async {
                self.setupWithMovie(movie)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .imagesSectionDidSelectedImage)) { imageInfos in
            guard let notificationObject = imageInfos.object as? (UIImage, CGFloat) else { return }
           
            self.selectedImage = notificationObject
            self.isModalShown = true
            self.imageLinkSelection = 2
        }
        .sheet(isPresented: self.$isModalShown) {
            MovieImageViewerView(selectedImage: self.selectedImage)
        }
    }
}


// MARK: - ROWS ViEWs
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
            }
            .foregroundColor(.white)
                        
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
            if _movie.popularity != nil {
                Divider()
                VStack(alignment: .center, spacing: 10) {
                    Text("POPULARITY")
                        .font(.subheadline)
                    Text(verbatim: "\(_movie.popularity!)")
                        .font(.headline)
                }
            }
        }
        .frame(maxWidth:.infinity)
        .padding(.vertical, 5)
    }
    
    // MARK: Trailer Button
    var trailerButton: some View {
        Button(action: { self.playTrailer() }) {
            HStack(spacing: 5) {
                Image(systemName: "play")
                    .imageScale(.small)
                Text("TRAILER")
                    .font(.subheadline)
            }.foregroundColor(.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .padding(.vertical, 5)
        }
            .padding(.horizontal)
            .background(Color.init(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemYellow)))
    }
    
    // MARK: Overview
    var overviewView: some View {
        Text("\(_movie.overview)")
            .padding(.vertical, 10)
            .layoutPriority(1)
    }
    
    // MARK: Extra Details
    var extraDetailsView: some View {
        Group {
            
            // MARK: Spoken Language
            VStack(alignment: .leading, spacing: 10) {
                Text("Spoken Languages:").bold()
                Text(_movie.languages).layoutPriority(1)
            }
            
            // MARK: Budget
            Text("Budget: ").bold() + Text("\(self.budget.toCurrency ?? "")")
            
            // MARK: Revenue
            Text("Revenue: ").bold() + Text("\(self.revenue.toCurrency ?? "")")
            
            Group {
                // MARK: Production Companies
				HStack {
					VStack(alignment: .leading, spacing: 10) {
						Text("Production Companies:").bold()
						
						Text("\(self.productionCompanies.compactMap { "\($0.name)" }.joined(separator: "\n"))")
							
							.onTapGesture { self.productionCompanyLinkSelection = 2 }
						
					}
					.layoutPriority(1)
					.fixedSize()
					NavigationLink(destination: ProductionCompaniesView(productionCompanies: productionCompanies), tag: 2, selection: $productionCompanyLinkSelection) {
						Text("")
					}
				}
              
                // MARK: Production Countries
                VStack(alignment: .leading, spacing: 10) {
                    Text("Production Countries:").bold()
                    Text("\(self.productionCountries.compactMap {$0.name}.joined(separator: "\n"))").layoutPriority(1)
                }
            }
        }
    }
    
    // MARK: Movie Images
    var movieImagesView: some View {
        _movie.movieImages.count > 4 ? MovieImagesView(data: Array(_movie.movieImages.prefix(upTo: 4))) : MovieImagesView(data: Array(_movie.movieImages[0..<_movie.movieImages.count]))
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

            self.movieImages = unwrappedImages.posters
            
            if unwrappedImages.posters.count > 4 {
                self.movieImagesCounting.toggle()
            }
            
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

// MARK: Section Headers
extension DetailView {
   
    var detailsSectionHeader: some View {
        Text("Details")
            .bold()
            .background(Color.white)
            .frame(maxWidth: .infinity)
    }
    
    // MARK: Movie Images Section Header
    var ImagesViewSectionHeader: some View {
        HStack {
            Text("Images").bold()
            Spacer()
            if self.movieImagesCounting {
                HStack {
                    NavigationLink(destination: MovieImagesCollectionView(movie: _movie, images: self.movieImages),
                                   tag: 1,
                                   selection: self.$imageLinkSelection) {
                                    EmptyView()
                    }
                    Button("See All") { self.imageLinkSelection = 1}
                        .foregroundColor(Color(.systemBlue))
                }
            }
        }
    }
}


