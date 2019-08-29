//
//  Webservice.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation
import Combine


class Webservice {
    
    static let shared = Webservice()
    
    func fetchMovies<T: Codable>(atEndpoint endpoint: Endpoint) -> AnyPublisher<T, Error> {
        
        let url = TMDBAPI.getEndpointUrl(endpoint)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder.decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
