//
//  DetailView.swift
//  elf.fetcher.moviesDetails.first
//
//  Created by Ghaff Ett on 29/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine
/*import Kingfisher
import KingfisherSwiftUI*/

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
    
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
   // @ViewBuilder
    var body: some View {
        
        GeometryReader {g in
            List {
                
                // MARK: Top Section
                self.topSection.frame(height: g.size.height * 0.7)
                
                // MARK: Rating View
                self.ratingView
                
                // MARK: Overview
                self.overviewView
                
                // MARK: Cast & Crew
                VStack {
                    if self.movieDetails.credits != nil {
                        PickerView(selection: self.$fetcher.creditPickerSelection, data: ["Cast", "Crew"])
                            .padding(.vertical, 2)
                        
                        MovieCreditsView(credits: self.fetcher.creditPickerSelection == 0 ? self.movieDetails.credits!.cast : self.movieDetails.credits!.crew)
                    } else {
                        EmptyView()
                    }
                }

                // MARK: Images
                VStack(spacing: 8) {
                    if !self.movieDetails.movieImages.isEmpty {
                        self.ImagesViewSectionHeader
                        self.movieImagesView
                    }
                }
                
                // MARK: Extra Details
               /* if self.movieDetails != Movie.placeholder {
                    self.extraDetailsView
                }*/
                
                // MARK: Reviews
                VStack(spacing: 8) {
                    if self.movieDetails.reviews != nil {
                        if self.movieDetails.reviews!.totalResults > 0 {
                            
                            self.ReviewsSectionHeader
                            self.movieReviewsView
                        }
                    }
                }
            }
            .navigationBarTitle(Text(verbatim: self.movieDetails.title), displayMode: .inline)
        }
        .onReceive(self.fetcher.$isDetailsLoaded) { (loaded) in
            
            if !self.fetcher.moviesDetails.isEmpty {
                if let movieDetails = self.fetcher.moviesDetails.first(where: { $0.id == self.movieId }) {
                    self.movieDetails = movieDetails
                } else {
                    debugPrint("New movie ---> \(self.movieId)")
                    //self.fetcher.fetchMoviesDetails(withIDS: [self.movieId])
                }
            } else {
                return
            }
        }
    }
}


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
