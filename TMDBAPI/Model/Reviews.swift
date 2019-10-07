//
//  Reviews.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct Reviews: Codable {
    let results: [Review]
    
    static var placeholder: Reviews {
        .init(results: [])
    }
}

struct Review: Codable {
    let id: String
    let author: String
    let content: String
    let url: String
}

extension Review: Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}
