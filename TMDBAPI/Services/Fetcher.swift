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
    @Published var movieDetails = Movie.placeholder
    @Published var genres = [Genre]()
    @Published var reviews = [Review]()
    @Published var images = [MovieImage]()
	@Published var creditPickerSelection = 0
	@Published var credits = ([Cast](), [Crew]())
	@Published var person = Person.placeholder
    
    var moviesCancellable: AnyCancellable?
    var movieDetailsCancellable: AnyCancellable?
    var reviewsCancellable: AnyCancellable?
    var imagesCancellable: AnyCancellable?
	var creditsCancellable: AnyCancellable?
	var personSubscriber: AnyCancellable?
    
    init() {
        //self.fetchMovies()
    }
	
	deinit {
		debugPrint(#function)
		moviesCancellable?.cancel()
		movieDetailsCancellable?.cancel()
		reviewsCancellable?.cancel()
		imagesCancellable?.cancel()
		creditsCancellable?.cancel()
	}
	
	func cancel() {
		moviesCancellable?.cancel()
		movieDetailsCancellable?.cancel()
		reviewsCancellable?.cancel()
		imagesCancellable?.cancel()
		creditsCancellable?.cancel()
	}
	
	func cancelPersonPublisher() {
		self.personSubscriber?.cancel()
	}
}

// MARK: - Helpers
extension Fetcher {
    
	// MARK: Fetch Movies
	func fetchMovies(atEndpoint endpoint: Endpoint = .popular) {
        
        let anyPub: AnyPublisher<RequestResponse, Error> = Webservice.shared.getData(atEndpoint: endpoint)
        
        moviesCancellable = anyPub
            .map { $0.results }
            .catch { err -> Just<[Movie]> in
				debugPrint("Error decoding movies: \(err.localizedDescription)")
                return Just([])
            }
        .assign(to: \.movies, on: self)
    }
    
	// MARK: Fetch Movie Details
    func fetchMovieDetails(_ movie: Movie) {
        let parameters = ["append_to_response":"videos,images"].compactMapValues { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)}
        
        let detailsPublisher: AnyPublisher<Movie, Error> = Webservice.shared.getData(atEndpoint: .details(movie.id), parameters: parameters)
        
        movieDetailsCancellable = detailsPublisher
            .map { $0 }
            .catch { err -> Just<Movie> in
                debugPrint("Movie details error --> \(err.localizedDescription)")
                return Just(Movie.placeholder)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.movieDetails, on: self)
        
    }
	
	// MARK: Fetch Movie Credits
	func fetchMovieCredits(_ movie: Movie) {
		let creditsPublisher: AnyPublisher<Credits, Error> = Webservice.shared.getData(atEndpoint: .credits(movie.id))
		
		creditsCancellable = creditsPublisher
			.map { ($0.cast, $0.crew) }
			.catch { err -> Just<([Cast], [Crew])> in
				debugPrint("Movie credits error -> \(err.localizedDescription)")
				return Just(([], []))
			}
			.receive(on: DispatchQueue.main)
			.assign(to: \.credits, on: self)
	}
    
	// MARK: Fetch Movie Reviews
    func fetchMovieReviews(_ movie: Movie) {
        
        let reviewsPublisher: AnyPublisher<Reviews, Error> = Webservice.shared.getData(atEndpoint: .reviews(movie.id))
        
        reviewsCancellable = reviewsPublisher
            .map { $0.results }
            .catch { err -> Just<[Review]> in
                debugPrint("Movie reviews error --> \(err.localizedDescription)")
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
	
	// MARK: Fetch Credit Details
	func fetchPersonDetails(_ credit: Credit) {
				
		let personPublisher: AnyPublisher<Person, Error> = Webservice.shared.getData(atEndpoint: .person(credit.ID))
		
		personSubscriber = personPublisher
			.map { $0 }
			.catch { err -> Just<Person> in
				debugPrint("Person error --> \(err)")
				return Just(Person.placeholder)
		}
		.receive(on: DispatchQueue.main)
		.assign(to: \.person, on: self)
	}
}
