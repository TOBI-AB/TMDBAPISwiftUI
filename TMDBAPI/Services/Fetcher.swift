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
    
    var cancellable: AnyCancellable?
    var detailsCancellable: AnyCancellable?
    var reviewsCancellable: AnyCancellable?
    
    init() {
        self.fetchMovies()
    }
}

extension Fetcher {
    
    func fetchMovies(atEndpoint endpoint: Endpoint = .upcoming) {
        
        let anyPub: AnyPublisher<RequestResponse, Error> = Webservice.shared.getData(atEndpoint: endpoint)
        
        cancellable = anyPub
            .map { $0.results }
            .catch { err -> Just<[Movie]> in
                debugPrint("Error decoding: \(err)")
                return Just([])
            }
        .assign(to: \.movies, on: self)
    }
    
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
    
    
}
