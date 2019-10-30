//
//  API.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation
import Kingfisher


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
    case personeMovies(Int)
    case collection(Int)
    
    var stringValue: String {
        switch self {
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        case .nowPlaying:
            return "Now Playing"
        default:
            return ""
        }
    }
    
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
        case .personeMovies(let id):
            return "/person/\(id)/movie_credits"
        case .collection(let id):
            return "/collection/\(id)"
        }
    }
}

enum ImageType {
    case backdrop
    case logo
    case poster
    
    private enum BackdropSize: String {
        case w300
        case w780
        case w1280
        case original
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
            fatalError("Endpoint: \(endpoint.rawValue), bad url: \(String(describing: urlCom?.url))")
        }
        
        return endpointUrl
    }
    
    static func getMoviePosterUrl(_ posterPath: String?, withSize size: String = "w500") -> URL? {
        guard let unwrappedPosterPath = posterPath else { return nil }
        let posterUrlString = "https://image.tmdb.org/t/p/\(size)".appending(unwrappedPosterPath)
        
        guard let posterUrl = URL(string: posterUrlString) else {
            return nil
        }
        
        return posterUrl
    }
    
    static func imageResource(for path: String?) -> Source? {
        
        guard let url = self.getMoviePosterUrl(path) else {
            return nil
        }
        
        return .network(ImageResource(downloadURL: url, cacheKey: path))
    }
}


/*
 "backdrop_sizes": [
            "w300",
            "w780",
            "w1280",
            "original"
        ],
        "logo_sizes": [
            "w45",
            "w92",
            "w154",
            "w185",
            "w300",
            "w500",
            "original"
        ],
        "poster_sizes": [
            "w92",
            "w154",
            "w185",
            "w342",
            "w500",
            "w780",
            "original"
        ],
 */
