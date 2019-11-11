//
//  PersonMovie.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 04/10/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct PersonMovies: Codable {
    var cast: [PersonMoviesCast]
    var crew: [PersonMoviesCrew]
}

struct PersonMoviesCast: Codable {
    let character: String?
    let creditId: String
    let posterPath: String?
    let id: Int
    let title: String?
}

/*extension PersonMoviesCast: Credit {
    var creditName: String {
        character ?? ""
    }
    
    var creditIdentifier: String {
        creditId
    }
    
    var creditProfilePath: String? {
        posterPath
    }
    
    var extraInfo: String {
        title ?? ""
    }
    
    var ID: Int {
        id
    }
}
*/
struct PersonMoviesCrew: Codable {
    let job: String
    let creditId: String
    let posterPath: String?
    let id: Int
    let title: String
}
/*
extension PersonMoviesCrew: Credit {
    var creditName: String {
        job
    }
    
    var creditIdentifier: String {
        creditId
    }
    
    var creditProfilePath: String? {
        posterPath
    }
    
    var extraInfo: String {
        title
    }
    
    var ID: Int {
        id
    }
}
*/
