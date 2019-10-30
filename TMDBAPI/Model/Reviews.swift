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
    let totalResults: Int
    static var placeholder: Reviews {
        .init(results: [], totalResults: .init())
    }
}

struct Review: Codable {
    let id: String
    let author: String
    var content: String
    let url: String
}

extension Review: Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}
