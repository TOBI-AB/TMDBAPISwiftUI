//
//  DetailView.swift
//  elf.fetcher.moviesDetails.first
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
   
    
    @State private var movieDetails: Movie?// = Movie.placeholder
    
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
    
    
    var body: some View {
        
        self.contentView
            .navigationBarTitle(Text(verbatim: "\(self.title)"), displayMode: .inline)
    }
    
    var contentView: some View {
        GeometryReader { g -> AnyView in
            if !self.fetcher.moviesDetails.isEmpty, let movieDetails = self.fetcher.moviesDetails.first(where: { $0.id == self.movieId }) {
                return DetailsView(movieDetails: movieDetails, size: g.size).eraseToAnyView()
            } else {
                return Text("Loading \(self.title)...")
                    .font(.headline)
                    .eraseToAnyView()
            }
        }
    }
}



// MARK: - Details View
struct DetailsView: View {
    
    @State private var imagesNavigationLinkSelection: Int?
    @State private var reviewsNavigationLinkSelection: Int?
    
    let movieDetails: Movie
    let size: CGSize
    
    var body: some View {
        List {
            topSectionView
            
            overview
            
            Section(header: imagesSectionHeader) {
                images
                    .frame(height: size.height * 0.2)
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
        }
    }
    
    // Top Section
    var topSectionView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(self.movieDetails.originalTitle)
                .font(.system(.title, design: .rounded))
                .bold()
                .layoutPriority(1)
            
            if self.movieDetails.genres != nil {
                Text(self.movieDetails.genres!.compactMap({$0.name}).joined(separator: " • "))
                    .font(.system(size: 14))
                
            }
        }
    }
    
    // Overview
    var overview: some View {
        Text(self.movieDetails.overview)
            .font(.system(size: 15))
            .padding(.vertical, 5)
    }
    
    // Images
    var images: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                self.movieDetails.movieImages.count > 4 ? MovieImagesView(data: Array(self.movieDetails.movieImages.prefix(upTo: 4))) : MovieImagesView(data: self.movieDetails.movieImages)
            }
        }
    }
    
    // Review View
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
    
    // Review Content View
    struct ReviewView: View {
        let review: Review
        
        var body: some View {
            TextView(text: review.content)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .navigationBarTitle("\(review.author.capitalized) Review")
        }
    }
    
    // Reviews List View
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
}

// MARK: Sections Headers
extension DetailsView {
    
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

/*
// MARK: Rows Views
extension MovieDetailsView {
    
    // MARK: - Top Section
    var topSection: some View {
       
        ZStack(alignment: .bottom) {
          
            // Poster
            /*ZStack(alignment: .bottom) {
                KFImage(source: TMDBAPI.imageResource(for: self.movieDetails.posterPath))
                    .resizable()
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
            }*/
            
            // Details: Title, genres, runtime, trailer
            VStack(alignment: .leading, spacing: 10) {
                 titleView
                 
              //   genresView
                 
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
        .listRowInsets(EdgeInsets.zero)
        .sheet(isPresented: self.$isTrailerPresented) {
            SafariController(url: self.movieTrailerUrl)
        }
    }
    
    
    // Title View
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
    
    // Genres View
    /*@ViewBuilder
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
    }*/
    
    // Trailer Button
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
      
        HStack {
        
            VStack(alignment: .center, spacing: 10) {
                Text("RATING")
                    .font(.subheadline)
                Text(verbatim: "\(movieDetails.voteAverage)")
                    .font(.headline)
            }.padding(.horizontal)
            
            if movieDetails.voteCount != nil {
                Divider()
                VStack(alignment: .center, spacing: 10) {
                    Text("VOTES")
                        .font(.subheadline)
                    Text(verbatim: "\(movieDetails.voteCount!)")
                        .font(.headline)
                }.padding(.horizontal)
            }
            
            if movieDetails.popularity != nil {
                Divider()
                VStack(alignment: .center, spacing: 10) {
                    Text("POPULARITY")
                        .font(.subheadline)
                    Text(verbatim: "\(movieDetails.popularity!)")
                        .font(.headline)
                }.padding(.horizontal)
            }
        }
        .frame(maxWidth:.infinity)
        .padding(.vertical, 5)
    }
    
    // MARK: - Overview
    var overviewView: some View {
        Text("\(movieDetails.overview)")
            .font(.body)
            .frame(maxWidth: .infinity)
            .layoutPriority(1)
            
    }
    
    // MARK: - Extra Details
    @ViewBuilder
  /*  var extraDetailsView: some View {
        
        // MARK: Collection
        /*if movieDetails.belongsToCollection != nil {
            NavigationLink(destination: MovieCollectionView(collection: movieDetails.belongsToCollection!)) {
                Text("Belongs to ") //+ Text("\(movieDetails.belongsToCollection!._name)").bold()
            }
        }*/
        
        // MARK: Spoken Language
        VStack(alignment: .leading, spacing: 5) {
            Text("Spoken Languages:").bold()
            Text(movieDetails.languages)
               // .font(.system(size: 15))
            Text(<#T##content: StringProtocol##StringProtocol#>)
            
        }
        // MARK: Budget
        if movieDetails.budget != nil {
            Text("Budget: ").bold() + Text("\(movieDetails.budget!.toCurrency)")
        }
                
        // MARK: Revenue
        if movieDetails.revenue != nil {
            Text("Revenue: ").bold() + Text("\(movieDetails.revenue!.toCurrency)")
        }
        
        // MARK: Production Countries
        if !movieDetails.productionCountries.isNilAndEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text("Production Countries:")
                    .bold()
                Text("\(movieDetails.productionCountries!.compactMap {$0.name}.joined(separator: "\n"))")
                    .layoutPriority(1)
            }
        }
        
        // MARK: Production Companies
        if !movieDetails.productionCompanies.isNilAndEmpty {
            NavigationLink(destination: ProductionCompaniesView(productionCompanies: movieDetails.productionCompanies!)){
                Text("Production Companies")
                   // .font(.system(size: 15))
                    .padding(.vertical, 5)
            }
        }
    }*/
    
    // MARK: - Movie Images
    var movieImagesView: some View {
        movieDetails.movieImages.count > 4 ? MovieImagesView(data: Array(movieDetails.movieImages.prefix(upTo: 4))) : MovieImagesView(data: Array(movieDetails.movieImages[0..<movieDetails.movieImages.count]))
    }
    
    // MARK: - Movie Reviews
    var movieReviewsView: some View {
        movieDetails.reviews!.totalResults > 2 ?
            ReviewsView(reviews: Array(movieDetails.reviews!.results.prefix(upTo: 2))) :
            ReviewsView(reviews: Array(movieDetails.reviews!.results[0..<movieDetails.reviews!.totalResults]))
    }
    
    // MARK: Reviews Rows
    fileprivate struct ReviewsView: View {
        let reviews: [Review]
        var body: some View {
            VStack(spacing: 5) {
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
            Text("IMAGES").bold()
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
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: Reviews Section Header
    var ReviewsSectionHeader: some View {
     
        HStack {
            Text("REVIEWS").bold()
            Spacer()
           
            if self.movieDetails.reviews!.totalResults > 3 {
                HStack {
                    NavigationLink(destination:Text("List Details"),
                                   tag: 2,
                                   selection: self.$reviewsNavigationLinkSelection)
                    {
                            EmptyView()
                    }
                    Button("See All") { self.reviewsNavigationLinkSelection = 2 }
                        .foregroundColor(Color(.systemBlue))
                }
            } else {
                EmptyView()
        }
        }
    }
}
*/
