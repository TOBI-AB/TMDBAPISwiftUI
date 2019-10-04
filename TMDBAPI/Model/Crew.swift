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

extension Crew: Credit {
	
	var creditIdentifier: String {
		creditId
	}
	
	var ID: Int {
		id
	}
	
	var type: CreditType {
		.crew
	}
	
	var creditName: String {
		name
	}
	
	var extraInfo: String {
		job
	}
	
	var creditProfilePath: String? {
		profilePath
	}
}
