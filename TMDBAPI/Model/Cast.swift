//
//  Cast.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct Cast: Codable, Hashable {
	let castId: Int
	let character: String
	let creditId: String
	let id: Int
	let name: String
	let order: Int
	let profilePath: String?
}

extension Cast: GenericCodable {
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
        character
    }
}

/*extension Cast: Credit {
	
	var type: CreditType {
		.cast
	}
	
	var ID: Int {
		id
	}
	
	var creditIdentifier: String {
		creditId
	}
	
	var creditName: String {
		name
	}
	
	var extraInfo: String {
		character
	}
	
	var creditProfilePath: String? {
		profilePath
	}
}*/
