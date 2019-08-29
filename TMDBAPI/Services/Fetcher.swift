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
    
    var cancellable: AnyCancellable?
    
    init() {
        self.fetchMovies(atEndpoint: .popular)
    }
}

extension Fetcher {
    
    func fetchMovies(atEndpoint endpoint: Endpoint) {
        
        let anyPub: AnyPublisher<RequestResponse, Error> = Webservice.shared.fetchMovies(atEndpoint: endpoint)
        
        cancellable = anyPub
            .map { $0.results }
            .catch { err -> Just<[Movie]> in
                debugPrint("Error decoding: \(err)")
                return Just([])
            }
            .assign(to: \.movies, on: self)
    }
}
