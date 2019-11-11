//
//  Credits.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

enum GenericCodableType {
    case movie, cast, crew
}

protocol GenericCodable {
    var type: GenericCodableType { get }
    var identifier: String { get }
    var typeTitle: String { get }
    var typeExtraInfo: String { get }
    var typeProfileImageUrl: String { get }
    
}

extension GenericCodable {
    var typeProfileImageUrl: String {
        ""
    }
    
    var typeExtraInfo: String {
        ""
    }
}



// MARK: - Credits
struct Credits: Codable {
	let cast: [Cast]
	let crew: [Crew]
}
