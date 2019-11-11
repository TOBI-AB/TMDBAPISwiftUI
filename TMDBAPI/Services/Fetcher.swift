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
    @Published var similarMovies = [Movie]()
    @Published var movieDetails = Movie.placeholder
    @Published var persons = [Person]()
    @Published var creditPickerSelection = 0
    @Published var person = Person.placeholder
    @Published var personMovies = ([PersonMoviesCast](), [PersonMoviesCrew]())
    @Published var personMoviesPickerSelection = 0
    @Published var movieCollectionDetails = MovieCollectionDetails.placeholder
    
    @Published var isDetailsLoaded = false
    @Published var isCreditDetailsLoaded = false
    
    var movieTypes = [Endpoint]()
    
    var movieType: Int = 0 {
        didSet {
            self.fetchMovies(atEndpoint: movieTypes[movieType], key:\.movies)
        }
    }
    	
    private var cancellables: Set<AnyCancellable> = []
    private var moviesCanc: AnyCancellable?
    
    var rt: AnyCancellable?
    
	
	deinit {
        cancellables.forEach { $0.cancel() }
	}
	
	func cancel() {
        cancellables.forEach { $0.cancel() }
	}
}

// MARK: - Helpers
extension Fetcher {
    
	// MARK: Fetch Movies
    func fetchMovies(atEndpoint endpoint: Endpoint, key path: ReferenceWritableKeyPath<Fetcher, [Movie]>) {
        
        let anyPub: AnyPublisher<RequestResponse, Error> = Webservice.shared.fetchData(atEndpoint: endpoint)
        
        moviesCanc = anyPub.prefix(4)
            .map { $0.results }
            .catch { err -> Just<[Movie]> in
                debugPrint("Error decoding movies: \(err.localizedDescription)")
                return Just([])
            }
        .receive(on: DispatchQueue.main)
        .assign(to: path, on: self)
      //  .store(in: &cancellables)
        
        moviesCanc?.store(in: &cancellables)//cancel()
    }
    
    // MARK: Fetch Movies Details
    func fetchMoviesDetails(withIDS ids: [Int]) {
        
        let parameters = ["append_to_response":"videos,images,credits,reviews"].compactMapValues {
            $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        
        let detailsPublishers = ids.map { id -> AnyPublisher<Movie, Error> in
            Webservice.shared.fetchData(atEndpoint: .details(id), parameters: parameters)
        }
        
       let detailsCanc = Publishers.MergeMany(detailsPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                    case .failure(let err):
                        debugPrint("Error movies details: \(err)")
                    case .finished:
                        DispatchQueue.main.async {
                            self.isDetailsLoaded.toggle()
                        }
                        break
                }
            }, receiveValue: { (movies) in
                //self.moviesDetails.removeAll()
                self.moviesDetails = movies
        })
        
        detailsCanc.cancel()
    }
    
    // MARK: Fetch Casts & Credits details
    func fetchPersonsDetails(withIDS ids: [Int]) {
        let personsPublishers = ids.map { id -> AnyPublisher<Person, Error> in
            Webservice.shared.fetchData(atEndpoint: .person(id))
        }
        
        let personsDetailsCanc = Publishers.MergeMany(personsPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                    case .failure(let err):
                        debugPrint("Error fetching persons details details: \(err)")
                    case .finished:
                        break
                }
            }, receiveValue: { (persons) in
                self.persons = persons
            })
        
        personsDetailsCanc.cancel()
    }
    
    // MARK: Fetch Credit Details
   /* func fetchCreditDetails(_ credit: Credit) {
        
        let personPublisher: AnyPublisher<Person, Error> = Webservice.shared.fetchData(atEndpoint: .person(credit.ID))
        
        let personCanc = personPublisher
            .map { $0 }
            .catch { err -> Just<Person> in
                debugPrint("Error fetching Person details--> \(err)")
                return Just(Person.placeholder)
            }
        .assign(to: \.person, on: self)
        
        personCanc.cancel()
        
    }
    
    // MARK: Fetch Person Movies
    func fetchPersonMovies(_ person: Credit) {

        let personMoviesPublisher: AnyPublisher<PersonMovies, Error> = Webservice.shared.fetchData(atEndpoint: .personeMovies(person.ID))
        
        let personMoviesCanc = personMoviesPublisher
            .map { ($0.cast, $0.crew) }
            .catch { err -> Just<([PersonMoviesCast], [PersonMoviesCrew])> in
                debugPrint("Person Movie error -> \(err)")
                return Just(([], []))
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.personMovies, on: self)
            
        personMoviesCanc.cancel()
    }
    */
    // MARK: Fetch Movie Collection
    func fetchMovieCollectionDetails(with id: Int) {
        let collectionPublisher: AnyPublisher<MovieCollectionDetails, Error> = Webservice.shared.fetchData(atEndpoint: .collection(id))
        
        let movieCollection = collectionPublisher
            .map { $0 }
            .catch({ (error) -> Just<MovieCollectionDetails> in
                debugPrint("Error fetching collection details: \(error)")
                return Just(MovieCollectionDetails.placeholder)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.movieCollectionDetails, on: self)

        movieCollection.cancel()

    }
}
