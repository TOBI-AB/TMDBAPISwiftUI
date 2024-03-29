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
struct MovieDetailsView: View {
    
    // MARK: Properties
    @EnvironmentObject var fetcher: Fetcher
   
    
    @State private var movieDetails = Movie.placeholder
    
    @State private var selectedImage = (UIImage(), CGFloat())
    @State private var imagesNavigationLinkSelection: Int?
    @State private var isImageViewerPresented = false
    
    @State private var movieTrailerUrl = ""
    @State private var isTrailerPresented = false
    
    @State private var creditPickerSelection: Int?
    @State private var reviewsNavigationLinkSelection: Int?
    
    let movieId: Int
    
    init(movieId: Int = .init()) {
        self.movieId = movieId
    }
    
    // MARK: Views
    var topSection: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .bottom) {
                KFImage(source: TMDBAPI.imageResource(for: self.movieDetails.posterPath))
                    .resizable()
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
            }
            self.detailsView
        }
        .listRowInsets(EdgeInsets.zero)
        .sheet(isPresented: self.$isTrailerPresented) {
            SafariController(url: self.movieTrailerUrl)
        }
        .onAppear {
            if let movieDetails = self.fetcher.moviesDetails.first(where: { $0.id == self.movieId })  {
                self.movieDetails = movieDetails
            }
        }
    }
    
    var body: some View {
        GeometryReader { g in
            List {
                
                // MARK: Top Section: Poster & Details View(Title, Year, Genres, Runtime & Trailer)
                self.topSection
                    .frame(height: g.frame(in: .global).size.height * 0.7)
                
                // MARK: Rating
                self.ratingView
                
                // MARK: Overview
                self.overviewView
                
                // MARK: Extra Details
                self.extraDetailsView
                
                // MARK: Movie Credits View
                if self.movieDetails.credits != nil {
                    Section(header: Text("CREDITS")) {
                        PickerView(selection: self.$fetcher.creditPickerSelection, data: ["Cast", "Crew"])
                            .padding(.vertical, 2)
                        
                        MovieCreditsView(credits: self.fetcher.creditPickerSelection == 0 ? self.movieDetails.credits!.cast : self.movieDetails.credits!.crew, proxy: g)
                            .onAppear {
                                self.fetcher.creditPickerSelection = 0
                        }
                    }
                }
                
                // MARK: Movie Images View
                if !self.movieDetails.movieImages.isEmpty {
                    Section(header: self.ImagesViewSectionHeader) {
                        self.movieImagesView
                    }
                }
                
                // MARK: Movi Reviews
                if self.movieDetails.reviews != nil {
                    if self.movieDetails.reviews!.totalResults > 0 {
                        Section(header: self.ReviewsSectionHeader) {
                            self.movieReviewsView
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(verbatim: self.movieDetails.title), displayMode: .inline)
        .opacity(self.fetcher.isDetailsLoaded ? 1 : 0)
        .onReceive(NotificationCenter.default.publisher(for: .imagesSectionDidSelectedImage)) { imageInfos in
            
            guard let notificationObject = imageInfos.object as? (UIImage, CGFloat) else { return }
            
            self.selectedImage = notificationObject
            self.isImageViewerPresented = true
            self.imagesNavigationLinkSelection = 2
        }
        .sheet(isPresented: self.$isImageViewerPresented) {
            MovieImageViewerView(selectedImage: self.selectedImage)
        }
        
    }	
}


// MARK: - Rows Views
extension MovieDetailsView {
    
    // MARK: Movie Poster
    var detailsView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            titleView
            
            genresView
            
            HStack {
                Text(verbatim: movieDetails.releaseDate)
                if movieDetails.runtime != nil {
                    Text("•").font(.headline)
                    Text(movieDetails.runtime!.toTime)
                }
            }
            .foregroundColor(.white)
                        
            if !movieDetails._videos.isEmpty {
                trailerButton
            }
       
        }.padding()
    }
    
    // MARK: Title View
    var titleView: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(movieDetails.originalTitle.uppercased())
                .bold()
                .modifier(TitleModifier())
            
            if movieDetails.originalTitle != movieDetails.title {
                Text(movieDetails.title)
                    .bold()
                    .modifier(TitleModifier())
            }
        }
    }
    
    // MARK: Genres View
    @ViewBuilder
    var genresView: some View {
        if !movieDetails.genres.isNilAndEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movieDetails.genres!.compactMap { $0.name }, id: \.self) { genreName in
                        Text(genreName)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(.systemYellow)))
                    }
                }
                .padding([.leading,.vertical],5)
            }
            .padding(.leading, -5)
        }
    }
    
    
    // MARK: Trailer Button
    var trailerButton: some View {
        Button(action: {
            self.movieTrailerUrl = self.trailerUrl
            self.isTrailerPresented.toggle()
        }) {
            HStack(spacing: 5) {
                Image(systemName: "play")
                    .imageScale(.small)
                Text("TRAILER")
                    .font(.subheadline)
            }
            .foregroundColor(Color.white)
            .padding(.vertical, 5)
        }
        .padding(.horizontal)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemYellow)))
    }
    
    // MARK: Rating View
    var ratingView: some View {
      
        HStack(spacing: 40) {
        
            VStack(alignment: .center, spacing: 10) {
                Text("RATING")
                    .font(.subheadline)
                Text(verbatim: "\(movieDetails.voteAverage)")
                    .font(.headline)
            }
            
            if movieDetails.voteCount != nil {
                Divider()
                VStack(alignment: .center, spacing: 10) {
                    Text("VOTES")
                        .font(.subheadline)
                    Text(verbatim: "\(movieDetails.voteCount!)")
                        .font(.headline)
                }
            }
            
            if movieDetails.popularity != nil {
                Divider()
                VStack(alignment: .center, spacing: 10) {
                    Text("POPULARITY")
                        .font(.subheadline)
                    Text(verbatim: "\(movieDetails.popularity!)")
                        .font(.headline)
                }
            }
        }
        .frame(maxWidth:.infinity)
        .padding(.vertical, 5)
    }
    
    // MARK: Overview
    var overviewView: some View {
        Text("\(movieDetails.overview)")
            .padding(.vertical, 5)
            .layoutPriority(1)
            .frame(maxWidth: .infinity)
    }
    
    // MARK: Extra Details
    @ViewBuilder
    var extraDetailsView: some View {
        
        // MARK: Spoken Language
        VStack(alignment: .leading, spacing: 8) {
            Text("Spoken Languages:").bold()
            Text(movieDetails.languages)
        }
          
        // MARK: Budget
        if movieDetails.budget != nil {
            Text("Budget: ").bold() + Text("\(movieDetails.budget!.toCurrency)")
        }
        
        // MARK: Revenue
        if movieDetails.revenue != nil {
            Text("Revenue: ").bold() + Text("\(movieDetails.revenue!.toCurrency)")
        }
        
        // MARK: Production Companies & Production Countries
        if !movieDetails.productionCountries.isNilAndEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Production Countries:")
                    .bold()
                Text("\(movieDetails.productionCompanies!.compactMap {$0.name}.joined(separator: "\n"))").layoutPriority(1)
            }
        }
        
        if !movieDetails.productionCompanies.isNilAndEmpty {
            NavigationLink(destination: ProductionCompaniesView(productionCompanies: movieDetails.productionCompanies!)){
                Text("Production Companies")
                    .padding(.vertical, 5)
            }
        }
    }
    
    // MARK: Movie Images
    var movieImagesView: some View {
        movieDetails.movieImages.count > 4 ? MovieImagesView(data: Array(movieDetails.movieImages.prefix(upTo: 4))) : MovieImagesView(data: Array(movieDetails.movieImages[0..<movieDetails.movieImages.count]))
    }
    
    // MARK: Movie Reviews
    var movieReviewsView: some View {
        movieDetails.reviews!.totalResults > 3 ?
            ReviewsView(reviews: Array(movieDetails.reviews!.results.prefix(upTo: 3))) :
            ReviewsView(reviews: Array(movieDetails.reviews!.results[0..<movieDetails.reviews!.totalResults ]))
    }
    
    // MARK: Movies Reviews
    struct ReviewsView: View {
        let reviews: [Review]
        var body: some View {
            VStack {
                ForEach(self.reviews, id: \.id) { review in
                    Group {
                        ReviewsRow(review: review)
                        if self.reviews.indexOfElement(review) < self.reviews.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - HELPERS
extension MovieDetailsView {
    
    // MARK: Trailer URL
    var trailerUrl: String {
         var trailerKey = ""
        
        guard let unwrappedVideos = movieDetails.videos else { return "" }
        
        let trailers = unwrappedVideos.results.filter { $0.type == "Trailer" }.sorted { $0.size > $1.size }
        
        trailerKey = (trailers.isEmpty) ? unwrappedVideos.results.sorted { $0.size > $1.size }[0].key : trailers[0].key
        
        return "https://www.youtube.com/watch?v=\(trailerKey)"
    }
}

// MARK: - Sections Headers
extension MovieDetailsView {
   
    // MARK: Movie Images Section Header
    var ImagesViewSectionHeader: some View {
        HStack {
            Text("IMAGES")//.bold()
            Spacer()
            if self.movieDetails.movieImages.count > 4 {
                HStack {
                    NavigationLink(destination: MovieImagesCollectionView(movie: movieDetails, images: movieDetails.movieImages),
                                   tag: 1,
                                   selection: self.$imagesNavigationLinkSelection)
                    {
                            EmptyView()
                    }
                    Button("See All") { self.imagesNavigationLinkSelection = 1}
                        .foregroundColor(Color(.systemBlue))
                }
            }
        }
    }
    
    // MARK: Reviews Section Header
    var ReviewsSectionHeader: some View {
     
        HStack {
            Text("REVIEWS")//.bold()
            Spacer()
           
            if self.movieDetails.reviews!.results.count > 3 {
                HStack {
                    NavigationLink(destination: ListReviewView(title: movieDetails.title, reviews: self.movieDetails.reviews!.results),
                                   tag: 2,
                                   selection: self.$reviewsNavigationLinkSelection)
                    {
                            EmptyView()
                    }
                    Button("See All") { self.reviewsNavigationLinkSelection = 2 }
                        .foregroundColor(Color(.systemBlue))
                }
            }
        }
    }
}
