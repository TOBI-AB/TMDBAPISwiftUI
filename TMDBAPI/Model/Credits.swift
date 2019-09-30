//
//  Credits.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

// MARK: Credit Protocol
protocol Credit {
	var type: CreditType { get }
	var ID: String { get }
	var creditName: String { get }
	var extraInfo: String { get }
	var creditProfilePath: String? { get }
}

extension Credit {
	var creditProfilePath: String? {
		nil
	}
}

// MARK: - Credit Protocol
enum CreditType: CaseIterable {
	case cast, crew
	
	static var allCases: [CreditType] {
		[.cast, .crew]
	}
	
	@available(*, unavailable)
	case all
}

// MARK: - Credits
struct Credits: Codable {
	let cast: [Cast]
	let crew: [Crew]
}
