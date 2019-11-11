//
//  DetailView.swift
//  elf.fetcher.moviesDetails.first
//
//  Created by Ghaff Ett on 29/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine

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
    @State private var isOverviewExpanded = false
    
    @State private var creditPickerSelection: Int?
    @State private var reviewsNavigationLinkSelection: Int?
    
    
    @State var movieTitle = ""
    
    let title: String
    let movieId: Int
    
    init(title: String, movieId: Int) {
        self.title = title
        self.movieId = movieId
    }
    
    
    var body: some View {
        
        self.contentView
            .navigationBarTitle(Text(""), displayMode: .inline)
            .onAppear {
        }
    }
    
    var contentView: some View {
        GeometryReader { g -> AnyView in
            if !self.fetcher.moviesDetails.isEmpty, let movieDetails = self.fetcher.moviesDetails.first(where: { $0.id == self.movieId }) {
                return DetailsView(movieDetails: movieDetails, size: g.size).eraseToAnyView()
            } else {
                return VStack {
                    Spacer()
                    Text("Loading \(self.title)...")
                    .padding()
                    Spacer()
                }.eraseToAnyView()
            }
        }
    }
}


// MARK: - Details View
struct DetailsView: View {
    
    @ObservedObject var fetcher = Fetcher()
    @State private var imagesNavigationLinkSelection: Int?
    @State private var reviewsNavigationLinkSelection: Int?
    @State private var creditPickerSelection = 0
    
    let movieDetails: Movie
    let size: CGSize
    
    init(movieDetails: Movie, size: CGSize) {
        self.movieDetails = movieDetails
        self.size = size
        self.fetcher.fetchMovies(atEndpoint: .similar(self.movieDetails.id), key: \Fetcher.similarMovies)
    }
    
    // MARK: - Main View
    var body: some View {
        List {
           
            // MARK: Top Section
            topSectionView
            
            // MARK: Rating View
            ratingView
            
            // MARK: Overview
            overview
            
            // MARK: Extra Details
            Section(header: CommonHeader(title: "Extra Details"), footer: EmptyView()) {
                extraDetailsView
            }
            
            // MARK: Cast & Crew
            if movieDetails.credits != nil {
                Section(header: CommonHeader(title: "Cast & Crew")) {
                    creditsView
                }
            }
            
            // MARK: Imags
            if !self.movieDetails.movieImages.isEmpty {
                Section(header: imagesSectionHeader) {
                    images
                        .frame(height: size.height * 0.2)
                }
            }
            
            if self.movieDetails.reviews != nil && !self.movieDetails.reviews!.results.isEmpty {
                Section(header: reviewsSectionHeader) {
                    ForEach(self.movieDetails.reviews!.results.count > 4 ? Array(self.movieDetails.reviews!.results.prefix(upTo: 4)) : self.movieDetails.reviews!.results, id: \.id) { review in
                        
                        NavigationLink(destination: ReviewView(review: review)) {
                            ReviewRow(review: review)
                        }
                    }
                }
            }
            
            // MARK: Similar Movies
            if !fetcher.similarMovies.isEmpty {
                Section(header: CommonHeader(title: "Similar Movies")) {
                    similarMoviesView
                }
            }
        }
    }
    
    // MARK: - Top Section
    var topSectionView: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Title
            Group {
                Text(self.movieDetails.originalTitle)
                
                if self.movieDetails.originalTitle != self.movieDetails.title {
                    Text(self.movieDetails.title)
                }
            }
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .frame(maxHeight: .infinity)
                    
            // Status, Year of production
            if !movieDetails.status.isNilAndEmpty {
                HStack(spacing: 5) {
                    Text(movieDetails.status!.localizedUppercase)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    
                    if movieDetails.releaseDate != nil {
                        Text("•")
                            .fontWeight(.semibold)
                        Text("\(movieDetails.releaseDate!.getComponents([.year]))").font(
                            .system(size: 14))
                    }
                }
            }
            
            // Genres
            if self.movieDetails.genres != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.movieDetails.genres!.compactMap({ $0.name}), id: \.self) { genre in
                            Text(genre)
                                .font(.system(size: 14))
                                .padding(2)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7)))
                        }
                        
                        Spacer(minLength: 25)
                    }
                    .padding([.leading,.vertical],5)
                }
                .padding(.leading, -5)
            }
        }.padding(.vertical, 5)
    }
    
    // MARK: - Rating View
    var ratingView: some View {
      
        HStack {
        
            VStack(alignment: .center, spacing: 5) {
                Text("RATING")
                Text(verbatim: "\(movieDetails.voteAverage)")
                    .fontWeight(.semibold)
            }.font(.system(size: 15)).padding(.horizontal)
            
            if movieDetails.voteCount != nil {
                Divider()
                VStack(alignment: .center, spacing: 5) {
                    Text("VOTES")
                    Text(verbatim: "\(movieDetails.voteCount!)")
                        .fontWeight(.semibold)
                }.font(.system(size: 15)).padding(.horizontal)
            }
            
            if movieDetails.popularity != nil {
                Divider()
                VStack(alignment: .center, spacing: 5) {
                    Text("POPULARITY")
                    Text(verbatim: "\(movieDetails.popularity!)")
                        .fontWeight(.semibold)
                }.font(.system(size: 15)).padding(.horizontal)
            }
        }
            .frame(maxWidth:.infinity)
    }
    
    // MARK: -  Overview
    var overview: some View {
        Text(self.movieDetails.overview)
            .font(.system(size: 15))
            .multilineTextAlignment(.leading)
            .frame(maxHeight: .infinity)
            .padding(.vertical, 5)
    }
    
    // MARK: -  Credits
    var creditsView: some View {
        VStack {
            Picker(selection: self.$creditPickerSelection, label: EmptyView()) {
                ForEach(0..<["Cast", "Crew"].count) {
                    Text(["Cast", "Crew"][$0])
                        .tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            MovieCreditsView(credits: self.creditPickerSelection == 0 ? self.movieDetails._credits.cast : self.movieDetails._credits.crew, size: self.size)
        }
    }
    
    // MARK: -  Images
    var images: some View {
        self.movieDetails.movieImages.count > 4 ? MovieImagesView(data: Array(self.movieDetails.movieImages.prefix(upTo: 4))) : MovieImagesView(data: self.movieDetails.movieImages)
    }
    
    // MARK: -  Review View
    struct ReviewRow: View {
        let review: Review
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(review.author.capitalized)
                    .bold()
                Text(review.content)
                    .lineLimit(4)
            }
            .font(.system(size: 15))
        }
    }
    
    // MARK: -  Review Content View
    struct ReviewView: View {
        let review: Review
        
        var body: some View {
            TextView(text: review.content)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .navigationBarTitle("\(review.author.capitalized) Review")
        }
    }
    
    // MARK: -  Reviews List View
    struct ReviewsView: View {

        let title: String
        let reviews: [Review]
        
        var body: some View {
            List {
                ForEach(self.reviews, id: \.id) { review in
                    NavigationLink(destination: ReviewView(review: review)) {
                        ReviewRow(review: review)
                    }
                }
            }
            .navigationBarTitle("\(title) Reviews")
        }
    }
    
    // MARK: - Similar Movies
    var similarMoviesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(self.fetcher.similarMovies.sorted(by: { $0._releaseDate > $1._releaseDate }), id: \.id) { movie in
                    RowView(genericType: movie)
                        .frame(width: self.size.width / 4)
                }
            }
            .padding(.vertical, 5)
        }
        .frame(height: self.size.height * 0.2)
    }
}

// MARK: - Extra Details View
extension DetailsView {
    
    // MARK: Extra Details
    var extraDetailsView: some View {
        Group {
            
            Text(movieDetails.movieStatus).bold() + Text(" \(movieDetails.movieReleaseDate)")
        
            if movieDetails.runtime != nil {
                Text("Runtime: ").bold() + Text("\(movieDetails.runtime!.toTime)")
            }
            
            if movieDetails.spokenLanguages != nil {
                languagesView
            }
          
            if movieDetails.budget != nil {
                budgetView
            }
            
            if movieDetails.revenue != nil {
                revenueView
            }
            
            if !movieDetails.productionCountries.isArrayNilAndEmpty {
                productionCountries
            }
        }
        .font(.system(size: 15))
    }
    
    // Spoken Language
    var languagesView: some View {
        Group {
            Text(movieDetails.spokenLanguages!.count > 1 ? "Spoken Languages:\n" : "Spoken Language: ").bold()
                +
           // VStack(alignment: .leading, spacing: 2) {
                Text("\(movieDetails.spokenLanguages!.compactMap {$0.name}.joined(separator: "\n"))")
           // }
        }
        .frame(maxHeight: .infinity)
        
    }

    // Budget
    var budgetView: some View {
        Text("Budget: ").bold() + Text("\(movieDetails.budget!.toCurrency)")
    }
    
    // Revenue
    var revenueView: some View {
        Text("Revenue: ").bold() + Text("\(movieDetails.revenue!.toCurrency)")
    }
        
    // Production Countries
    var productionCountries: some View {
        Group {
            Text(movieDetails.productionCountries!.count > 1 ? "Production Countries:\n" : "Production Country: ").bold() +
            Text("\(movieDetails.productionCountries!.compactMap {$0.name}.joined(separator: "\n"))")
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Sections Headers
extension DetailsView {
    
    // Common Header
    struct CommonHeader: View {
        let title: String
        
        var body: some View {
            Text(title)
                .bold()
                .font(.system(size: 15))
        }
    }
    
    // Images Section Headear
    var imagesSectionHeader: some View {
        HStack {
            Text("Images")
                .bold()
                .font(.system(size: 15))
            
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
                        .font(.system(size: 15, weight: .bold, design: .default))
                }
            }
        }
    }
    
    // Reviews Section Header
    var reviewsSectionHeader: some View {
        HStack {
            Text("Reviews")
                .bold()
                .font(.system(size: 15))
            
            Spacer()
            
            if self.movieDetails.reviews!.results.count > 4 {
                HStack {
                    NavigationLink(destination: ReviewsView(title: self.movieDetails.originalTitle, reviews: self.movieDetails.reviews!.results),
                                   tag: 2,
                                   selection: self.$reviewsNavigationLinkSelection)
                    {
                            EmptyView()
                    }
                    Button("See All") { self.reviewsNavigationLinkSelection = 2}
                        .foregroundColor(Color(.systemBlue))
                        .font(.system(size: 15, weight: .bold, design: .default))
                }
            }
        }
    }
}
