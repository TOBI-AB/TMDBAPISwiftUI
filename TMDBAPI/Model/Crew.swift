//
//  Crew.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct Crew: Codable {
	let creditId: String
	let departement: String?
	let id: Int
	let job: String
	let name: String
	let profilePath: String?
}

extension Crew: GenericCodable {
    var identifier: String {
        self.creditId
    }
    
    var type: GenericCodableType {
        .cast
    }
    
    var typeTitle: String {
        self.name
    }
    
    var typeProfileImageUrl: String {
        self.profilePath ?? ""
    }
    
    var typeExtraInfo: String {
        job
    }
}
