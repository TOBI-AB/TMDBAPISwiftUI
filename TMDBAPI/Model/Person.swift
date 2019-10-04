//
//  Person.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct Person: Codable {
	let birthday: String?
	let knownForDepartment: String?
	let deathday: String?
	let id: Int
	let name: String
	let alsoKnownAs: [String]?
	let biography: String?
	let popularity: Double?
	let placeOfBirth: String?
	let profilePath: String?
	let imdbId: String?
	let homepage: String?
	
	static var previewPlaceholder: Person {
		.init(birthday: "1964-09-02", knownForDepartment: "Acting", deathday: nil, id: 6384, name: "Keanu Reeves", alsoKnownAs: ["Киану Ривз","كيانو ريفز","키아누 리브스","基努·里维斯","קיאנו ריבס","Keanu Charles Reeves","Κιάνου Ριβς"], biography: biblio, popularity: 27.654, placeOfBirth: "Beirut, Lebanon", profilePath: "/bOlYWhVuOiU6azC4Bw6zlXZ5QTC.jpg", imdbId: "nm0000206", homepage: nil)
	}
	
	static var placeholder: Person {
		.init(birthday: "", knownForDepartment: "", deathday: nil, id: 0, name: "", alsoKnownAs: [], biography: "", popularity: 0.0, placeOfBirth: nil, profilePath: "", imdbId: "", homepage: nil)
	}
	
	static var biblio: String {
		"Keanu Charles Reeves is a Canadian actor. Reeves is known for his roles in Bill &amp; Ted's Excellent Adventure, Speed, Point Break, and The Matrix trilogy as Neo. He has collaborated with major directors such as Stephen Frears (in the 1988 period drama Dangerous Liaisons); Gus Van Sant (in the 1991 independent film My Own Private Idaho); and Bernardo Bertolucci (in the 1993 film Little Buddha). Referring to his 1991 film releases, The New York Times' critic, Janet Maslin, praised Reeves' versatility, saying that he \"displays considerable discipline and range. He moves easily between the buttoned-down demeanor that suits a police procedural story and the loose-jointed manner of his comic roles.\" A repeated theme in roles he has portrayed is that of saving the world, including the characters of Ted Logan, Buddha, Neo, Johnny Mnemonic, John Constantine and Klaatu."
	}
}
