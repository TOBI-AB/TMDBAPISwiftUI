//
//  MovieCollection.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/15/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct MovieCollectionDetails: Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [Movie]
    
    static var placeholder: MovieCollectionDetails {
        .init(id: Int(), name: "", overview: "", posterPath: nil, backdropPath: nil, parts: [])
    }
}
