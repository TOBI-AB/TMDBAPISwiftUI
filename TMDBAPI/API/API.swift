//
//  API.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case popular = "/movie/popular"
    case upcoming = "/movie/upcoming"
    case topRated = "/movie/top_rated"
    case nowPlaying = "/movie/now_playing"
    case latest = "/movie/latest"
}


struct TMDBAPI {
     static private var key = "40e70758e59746255ad62482f1451c70"
     static private var baseUrl = "https://api.themoviedb.org/3"   
}

extension TMDBAPI {
    
    static func getEndpointUrl(_ endpoint: Endpoint, parameters:[String: Any] = [:]) -> URL {
        
        var urlCom = URLComponents(string: self.baseUrl.appending(endpoint.rawValue))
        
        if !parameters.isEmpty {
            urlCom?.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: String(describing: $0.value))}
        }
        
        guard let endpointUrl = urlCom?.url else {
            fatalError("----- Error Url \(endpoint.rawValue) -----")
        }
        
        return endpointUrl
    }
    
    static func getMoviePoster(_ movie: Movie) -> URL? {
        
        let posterUrlString = "https://image.tmdb.org/t/p/w500".appending(movie.posterPath ?? "")
        
        guard let posterUrl = URL(string: posterUrlString) else {
            return nil
        }
        
        return posterUrl
    }
}

