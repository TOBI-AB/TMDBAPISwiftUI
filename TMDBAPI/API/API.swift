//
//  API.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

enum Endpoint {
    case popular
    case upcoming
    case topRated
    case nowPlaying
    case latest
    case details(Int)
    case genres
    case reviews(Int)
    case company(Int)
    case images(Int)
	case credits(Int)
	case person(Int)
    
    var rawValue: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .upcoming:
            return "/movie/upcoming"
        case .topRated:
            return "/movie/top_rated"
        case .nowPlaying:
            return "/movie/now_playing"
        case .latest:
            return "/movie/latest"
        case .details(let id):
            return "/movie/\(id)"
        case .genres:
            return "/genre/movie/list"
        case .reviews(let id):
            return "/movie/\(id)/reviews"
        case .company(let id):
            return "/company/\(id)"
        case .images(let id):
            return "/movie/\(id)/images"
		case .credits(let id):
			return "/movie/\(id)/credits"
		case .person(let id):
			return "/person/\(id)"
        }
    }
}


struct TMDBAPI {
     static private var key = "40e70758e59746255ad62482f1451c70"
     static private var baseUrl = "https://api.themoviedb.org/3"   
}

extension TMDBAPI {
    
    static func getEndpointUrl(_ endpoint: Endpoint, parameters:[String: Any] = [:]) -> URL {
        var _parameters: [String: Any]
        var urlCom = URLComponents(string: self.baseUrl.appending(endpoint.rawValue))
        
        if !parameters.isEmpty {
            _parameters = parameters.merging(["api_key" : self.key], uniquingKeysWith: { (_, new) in
                new
            })
            urlCom?.queryItems =  _parameters.compactMap { URLQueryItem(name: $0.key, value: String(describing: $0.value))}
        } else {
            urlCom?.queryItems = ["api_key": self.key].compactMap { URLQueryItem(name: $0.key, value: String(describing: $0.value))}
        }
        
        guard let endpointUrl = urlCom?.url else {
            fatalError("----- Error Url \(endpoint.rawValue) -----")
        }
                
        return endpointUrl
    }
    
    static func getMoviePosterUrl(_ posterPath: String?) -> URL? {
        guard let wrappedPosterPath = posterPath else { return nil }
        let posterUrlString = "https://image.tmdb.org/t/p/w500".appending(wrappedPosterPath)
        
        guard let posterUrl = URL(string: posterUrlString) else {
            return nil
        }
        
        return posterUrl
    }
}

