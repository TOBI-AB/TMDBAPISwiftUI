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
    
    @State private var _movieDetails = Movie.placeholder
    @State private var moviePosterPath = ""
    @State private var genres = [Genre]()
    @State private var reviews = [Review]()
    @State private var budget: Double = 0.0
    @State private var revenue: Double = 0.0
    @State private var productionCompanies = [ProductionCompany]()
	@State private var productionCompanyLinkSelection: Int? = nil
    @State private var productionCountries = [ProductionCountry]()
    @State private var movieImages = [MovieImage]()
    @State private var movieImagesCounting = false
    @State private var imageLinkSelection: Int? = nil
    @State private var isModalShown = false
    @State private var selectedImage = (UIImage(), CGFloat())
	@State private var creditPickerSelection = 0
	@State private var credits = [Person]()
    
    let movie: Movie
    
    // MARK: Initialization
    init(movie: Movie) {
        self.movie = movie
        self.fetcher.fetchMovieDetails(withId: movie.id)
		self.fetcher.fetchMovieCredits(movie)
		//self.fetcher.fetchMovieReviews(movie)
    }
    
    // MARK: Views
    var topSection: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack {
                KFImage(source: .network(ImageResource(downloadURL: TMDBAPI.getMoviePosterUrl(self.moviePosterPath)!,cacheKey: self.moviePosterPath)))
                    .resizable()
                    .cancelOnDisappear(true)
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom)
            }
        
			self.detailsView
     
		}.listRowInsets(EdgeInsets.zero)
    }
    
    var body: some View {
        GeometryReader { g in
            List {
                self.topSection
                    .frame(height: g.frame(in: .global).size.height * 0.7)
                
                self.ratingView
                
                self.overviewView

                self.extraDetailsView.environment(\.lineSpacing, 5)
 
                // MARK: Movie Images View
                Section(header: self.ImagesViewSectionHeader) {
                    self.movieImagesView
				}
			
                // MARK: Movie Credits View
                Section(header: Text("CREDITS").bold()) {
					
                    PickerView(selection: self.$fetcher.creditPickerSelection, data: ["Cast", "Crew"])
                        .padding(.vertical, 2)
					
					MovieCreditsView()
						.frame(minHeight: g.frame(in: .global).size.height * 0.25)
						.environmentObject(self.fetcher)
				}
			}
        }
		.navigationBarTitle(Text(verbatim: _movieDetails.title), displayMode: .inline)
        .onReceive(self.fetcher.$movieDetails) { (movieDetails) in
            DispatchQueue.main.async {
                self.setupWithMovie(movieDetails)
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
                Text(verbatim: _movieDetails.releaseDate)
                if _movieDetails.runtime != nil {
                    Text("•").font(.headline).foregroundColor(Color(.systemYellow))
                    Text(_movieDetails.runtime!.toTime)
                }
            }
            .foregroundColor(.white)
                        
            if !_movieDetails._videos.isEmpty {
                trailerButton
            }
       
        }.padding()
    }
    
    // MARK: Title View
    var titleView: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(_movieDetails.originalTitle.uppercased())
                .bold()
                .modifier(TitleModifier())
            
            if _movieDetails.originalTitle != _movieDetails.title {
                Text(_movieDetails.title)
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
                Text(verbatim: "\(_movieDetails.voteAverage)")
                    .font(.headline)
            }
            Divider()
            VStack(alignment: .center, spacing: 10) {
                Text("VOTES")
                    .font(.subheadline)
                Text(verbatim: "\(_movieDetails.voteCount)")
                    .font(.headline)
            }
            if _movieDetails.popularity != nil {
                Divider()
                VStack(alignment: .center, spacing: 10) {
                    Text("POPULARITY")
                        .font(.subheadline)
                    Text(verbatim: "\(_movieDetails.popularity!)")
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
        Text("\(_movieDetails.overview)")
            .padding(.vertical, 10)
            .layoutPriority(1)
    }
    
    // MARK: Extra Details
    var extraDetailsView: some View {
        Group {
            
            // MARK: Spoken Language
			VStack(alignment: .leading) {
				Text("Spoken Languages:")
					.bold()
					.padding(.vertical, 2)
				
				Text(_movieDetails.languages)
					.layoutPriority(1)
			}
            // MARK: Budget
            Text("Budget:\n").bold() + Text("\(self.budget.toCurrency ?? "")")
            
            // MARK: Revenue
            Text("Revenue:\n").bold() + Text("\(self.revenue.toCurrency ?? "")")
            
			// MARK: Production Companies & Production Countries
            Group {
                //  Production Countries
                VStack(alignment: .leading) {
					Text("Production Countries:").bold().padding(.vertical, 2)
                    Text("\(self.productionCountries.compactMap {$0.name}.joined(separator: "\n"))").layoutPriority(1)
                }
				
				NavigationLink(destination: ProductionCompaniesView(productionCompanies: productionCompanies)){//}, tag: 2, selection: $productionCompanyLinkSelection) {
					Text("Production Companies").padding(.vertical, 2)//Text("")
				}
            }
        }
    }
    
    // MARK: Movie Images
    var movieImagesView: some View {
        _movieDetails.movieImages.count > 4 ? MovieImagesView(data: Array(_movieDetails.movieImages.prefix(upTo: 4))) : MovieImagesView(data: Array(_movieDetails.movieImages[0..<_movieDetails.movieImages.count]))
    }
}

// MARK: - HELPERS
extension DetailView {
    fileprivate func setupWithMovie(_ movie: Movie) {
        self._movieDetails = movie
        
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
        
        guard let unwrappedVideos = _movieDetails.videos else { return }
        
        let trailers = unwrappedVideos.results.filter { $0.type == "Trailer" }.sorted { $0.size > $1.size }
        
        trailerKey = (trailers.isEmpty) ? unwrappedVideos.results.sorted { $0.size > $1.size }[0].key : trailers[0].key
        
        guard let trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)") else { return }
        
        if UIApplication.shared.canOpenURL(trailerUrl) {
            UIApplication.shared.open(trailerUrl, options: [: ])
        }
    }
}

// MARK: -
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
            Text("IMAGES").bold()
            Spacer()
            if self.movieImagesCounting {
                HStack {
                    NavigationLink(destination: MovieImagesCollectionView(movie: _movieDetails, images: self.movieImages),
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
	
	// MARK: Credits Picker
	var picker: some View {
		Picker(selection: self.$fetcher.creditPickerSelection, label: Text("")) {
			Text("Cast")
                .bold()
                .tag(0)
			Text("Crew")
                .bold()
                .tag(1)
		}
		.pickerStyle(SegmentedPickerStyle())
	}
}
