//
//  MovieTypeHandler.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/29/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Combine

class MovieTypeHandler: ObservableObject {
    
    static let shared = MovieTypeHandler()
    
    @Published var movieType: Int = 0 {
        didSet {
            self.fetchMovies()
        }
    }
    
    @ObservedObject var fetcher = Fetcher()
    
    private let movieTypes: [Endpoint] = [.nowPlaying, .popular, .topRated, .upcoming]
    
    
    private init() {}
    
    
    func fetchMovies() {
        let endPoint = self.movieTypes[movieType]
            
        self.fetcher.fetchMovies(atEndpoint: endPoint)
    }
}
