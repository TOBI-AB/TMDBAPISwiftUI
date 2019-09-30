//
//  Constants.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 27/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

class Constants {
	static var movies = [Movie]()
	
	
	static func getStaticMovies() -> [Movie] {
		
		guard let moviesJsonFileURL = Bundle.main.url(forResource: "StaticMovies", withExtension: "json") else {
			fatalError("Invalid Static Json File URL")
		}
				
		do {
			let staticMoviesData = try Data(contentsOf: moviesJsonFileURL)
			let json = try JSONDecoder.decoder.decode([Movie].self, from: staticMoviesData)
			
			return json
		} catch {
			debugPrint("Error parsing static movies: \(error)")
		}
		
		return []
	}
}
