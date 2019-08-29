//
//  MovieModel.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct RequestResponse: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let id: Int
    let backdropPath: String?
    let originalLanguage: String
    let originalTitle: String
    let genreIds: [Int]
    let voteAverage: Double
    let overview: String
    let releaseDate: String
    
}
