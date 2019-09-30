//
//  Fetcher.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation
import Combine

class Fetcher: ObservableObject {
   
    @Published var movies: [Movie] = []
    @Published var movieDetails: Movie = Movie.placeholder
    @Published var genres = [Genre]()
    @Published var reviews = [Review]()
    @Published var images = [MovieImage]()
	@Published var cast = [Cast]()
	@Published var crew = [Crew]()
	@Published var creditPickerSelection = 0
	@Published var credits = ([Cast](), [Crew]())
    
    var cancellable: AnyCancellable?
    var detailsCancellable: AnyCancellable?
    var reviewsCancellable: AnyCancellable?
    var imagesCancellable: AnyCancellable?
	var castCancellable: AnyCancellable?
	var crewCancellable: AnyCancellable?
    
    init() {
        self.fetchMovies()
    }
	
	deinit {
		cancellable?.cancel()
		detailsCancellable?.cancel()
		reviewsCancellable?.cancel()
		imagesCancellable?.cancel()
		castCancellable?.cancel()
		crewCancellable?.cancel()
	}
}

// MARK: - Helpers
extension Fetcher {
    
	// MARK: Fetch Movies
    func fetchMovies(atEndpoint endpoint: Endpoint = .nowPlaying) {
        
        let anyPub: AnyPublisher<RequestResponse, Error> = Webservice.shared.getData(atEndpoint: endpoint)
        
        cancellable = anyPub
            .map { $0.results }
            .catch { err -> Just<[Movie]> in
                debugPrint("Error decoding: \(err)")
                return Just([])
            }
        .assign(to: \.movies, on: self)
    }
    
	// MARK: Fetch Movie Details
    func fetchMovieDetails(_ movie: Movie) {
        let parameters = ["append_to_response":"videos,images"].compactMapValues { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)}
        
        let detailsPublisher: AnyPublisher<Movie, Error> = Webservice.shared.getData(atEndpoint: .details(movie.id), parameters: parameters)
        
        detailsCancellable = detailsPublisher
            .map { $0 }
            .catch { err -> Just<Movie> in
                debugPrint("Movie details error --> \(err)")
                return Just(Movie.placeholder)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.movieDetails, on: self)
        
    }
	
	// MARK: Fetch Movie Credits
	func fetchMovieCredits(_ movie: Movie) {
		let creditsPublisher: AnyPublisher<Credits, Error> = Webservice.shared.getData(atEndpoint: .credits(movie.id))
		
		castCancellable = creditsPublisher
			.map { ($0.cast, $0.crew) }
			.catch { err -> Just<([Cast], [Crew])> in
				debugPrint("Cast error -> \(err)")
				return Just(([], []))
			}
		.receive(on: DispatchQueue.main)
		.assign(to: \.credits, on: self)
		
		/*crewCancellable = creditsPublisher
			.map { $0.crew }
			.catch { err -> Just<[Crew]> in
				debugPrint("Cast error -> \(err)")
				return Just([])
			}//.print()
		.receive(on: DispatchQueue.main)
		.assign(to: \.crew, on: self)*/
	}
    
	// MARK: Fetch Movie Reviews
    func fetchMovieReviews(_ movie: Movie) {
        
        let reviewsPublisher: AnyPublisher<Reviews, Error> = Webservice.shared.getData(atEndpoint: .reviews(movie.id))
        
        reviewsCancellable = reviewsPublisher
            .map { $0.results }
            .catch { err -> Just<[Review]> in
                debugPrint("Movie details error --> \(err)")
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.reviews, on: self)
        
    }
    
	// MARK: Fetch Movie Images
    func fetchMovieImages(_ movie: Movie) {
        
        let imagesPubliser: AnyPublisher<MovieImages, Error> = Webservice.shared.getData(atEndpoint: .images(movie.id))
        
        imagesCancellable = imagesPubliser
            .map { $0.posters }
            .catch { err -> Just<[MovieImage]> in
                debugPrint("Movie images error --> \(err)")
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.images, on: self)
    }
}
