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
    @Published var moviesDetails = [Movie]()
    @Published var movieDetails = Movie.placeholder
    @Published var genres = [Genre]()
    @Published var reviews = [Review]()
	@Published var credits = ([Cast](), [Crew]())
    @Published var movieCredits = [([Cast](), [Crew]())]
    @Published var creditPickerSelection = 0
    @Published var person = Person.placeholder
    @Published var personMovies = ([PersonMoviesCast](), [PersonMoviesCrew]())
    @Published var personMoviesPickerSelection = 0
    
    @Published var isDetailsLoaded = false
	
    
    var moviesCancellable: AnyCancellable?
    var movieDetailsCancellable: AnyCancellable?
	var personSubscriber: AnyCancellable?
    var personMoviesCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        //self.fetchMovies()
    }
	
	deinit {
		/*moviesCancellable?.cancel()
		movieDetailsCancellable?.cancel()*/
        
        cancellables.forEach { $0.cancel() }
	}
	
	func cancel() {
		/*moviesCancellable?.cancel()
		movieDetailsCancellable?.cancel()*/
        cancellables.forEach { $0.cancel() }
	}
	
	func cancelPersonPublisher() {
		self.personSubscriber?.cancel()
	}
}

// MARK: - Helpers
extension Fetcher {
    
	// MARK: Fetch Movies
    func fetchMovies(atEndpoint endpoint: Endpoint = .upcoming) {
        
        let anyPub: AnyPublisher<RequestResponse, Error> = Webservice.shared.getData(atEndpoint: endpoint)
        
        _ = anyPub
            .map { $0.results }
            .catch { err -> Just<[Movie]> in
				debugPrint("Error decoding movies: \(err)")
                return Just([])
            }
        .assign(to: \.movies, on: self)
        .store(in: &cancellables)

    }
    
	// MARK: Fetch Credit Details
	func fetchPersonDetails(_ person: Credit) {
				
		let personPublisher: AnyPublisher<Person, Error> = Webservice.shared.getData(atEndpoint: .person(person.ID))
		
		_ = personPublisher
			.map { $0 }
			.catch { err -> Just<Person> in
				debugPrint("Person error --> \(err)")
				return Just(Person.placeholder)
		}
		.receive(on: DispatchQueue.main)
        .assign(to: \.person, on: self)
        .store(in: &cancellables)
	}
    
    // MARK: Fetch Person Movies
    func fetchPersonMovies(_ person: Credit) {

        let personMoviesPublisher: AnyPublisher<PersonMovies, Error> = Webservice.shared.getData(atEndpoint: .personeMovies(person.ID))
        
        _ = personMoviesPublisher
            .map { ($0.cast, $0.crew) }
            .catch { err -> Just<([PersonMoviesCast], [PersonMoviesCrew])> in
                debugPrint("Person Movie error -> \(err)")
                return Just(([], []))
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.personMovies, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: Fetrch Movies Details
    func fetchMoviesDetails(withIDS ids: [Int]) {
         let parameters = ["append_to_response":"videos,images,credits,reviews"].compactMapValues {
            $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        
        let detailsPublishers = ids.map { id -> AnyPublisher<Movie, Error> in
            Webservice.shared.getData(atEndpoint: .details(id), parameters: parameters)
        }
        
       _ = Publishers.MergeMany(detailsPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                    case .failure(let err):
                        debugPrint("Error movies details: \(err)")
                    case .finished:
                        self.isDetailsLoaded.toggle()
                        break
                }
            }, receiveValue: { (movies) in
                self.moviesDetails = movies
        }).store(in: &cancellables)
    }
}
