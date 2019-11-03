//
//  MovieModel.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

struct RequestResponse: Codable {
    var results: [Movie]
}

// MARK: - Main Modl
struct Movie: Codable {
    let popularity: Double?
    let voteCount: Int?
    let video: Bool
    let posterPath: String?
    let id: Int
    let images: MovieImages?
    let backdropPath: String?
    let originalLanguage: String
    let originalTitle: String
    let title: String
    let genres: [Genre]?
    let genreIds: [Int]?
    let budget: Double?
    let revenue: Double?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let runtime: Double?
    let voteAverage: Double
    let overview: String
    let releaseDate: String
    let spokenLanguages: [SpokenLanguage]?
    let videos: MovieVideos?
    let credits: Credits?
    let reviews: Reviews?
    let belongsToCollection: MovieCollection?
    
   
    struct MovieVideos: Codable {
        let results: [MovieVideo]
    }
    
    struct SpokenLanguage: Codable {
        let name: String
    }
        
    static var placeholder: Movie {
        Movie(popularity:Double(),
              voteCount:Int(),
              video:false,
              posterPath:"",
              id:420818,
              images: nil,
              backdropPath:"",
              originalLanguage:"",
              originalTitle:"",
              title: "",
              genres: nil,
              genreIds: nil,
              budget: nil,
              revenue: nil,
              productionCompanies: nil,
              productionCountries: nil,
              runtime: nil,
              voteAverage:Double(),
              overview: "",
              releaseDate: "",
              spokenLanguages: nil,
              videos: nil,
              credits: nil,
              reviews: nil,
              belongsToCollection: nil
        )
    }

    var languages: String {
        guard let unwrappedSpoLang = self.spokenLanguages else { return "" }
            
        let langs = unwrappedSpoLang.filter { !$0.name.isEmpty }.compactMap { $0.name }.joined(separator: "\n")
        
        return langs
    }
        
    var _videos: [MovieVideo] {
        guard let unwrappedVideos = self.videos?.results else {
            return []
        }
        
        return unwrappedVideos
    }
    
    var imagesUrls: [URL] {
        guard let unwrappedImages = self.images else { return [] }
        
        return unwrappedImages.posters.compactMap { TMDBAPI.getMoviePosterUrl($0.filePath) }
    }
    
    var movieImages: [MovieImage] {
        guard let unwrappedImages = self.images else { return [] }
        return unwrappedImages.posters
    }
}

// MARK: - Extensions
extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        
    }
}


// MARK: Sub Structs

struct MovieImages: Codable {
      let posters: [MovieImage]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct MovieGenre: Codable {
    let genres: [Genre]
}

struct MovieImage: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let width: Int
    let voteCount: Int
    
    static var placeholder: MovieImage {
        MovieImage(aspectRatio: 0.0, filePath: "", height: 0, width: 0, voteCount: 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio,filePath,height,width,voteCount
    }
}

struct MovieVideo: Codable {
    let key: String
    let type: String
    let size: Int
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry: Codable {
    let name: String
}

struct MovieCollection: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    
    var _name: String {
        return (self.name.hasPrefix("the") || self.name.hasPrefix("The")) ? name : "the \(self.name)"
    }
}
