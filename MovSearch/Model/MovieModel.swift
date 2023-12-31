//
//  MovieModel.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation

struct MoviesResp: Codable {
    let page: Int
    let results: [MovieModel2]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieModel2: Codable, Identifiable {
     let id: Int

}

struct FavoritesMoviesResp: Codable {
    let page: Int
    let results: [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieModel: Codable, Identifiable {
     let adult: Bool
     let backdropPath,posterPath: String?
     let genreIDS: [Int]
     let id: Int
     let originalLanguage, originalTitle, overview: String
     let popularity: Double
     let releaseDate, title: String
     let video: Bool
     let voteAverage: Double
     let voteCount: Int

     enum CodingKeys: String, CodingKey {
         case adult
         case backdropPath = "backdrop_path"
         case genreIDS = "genre_ids"
         case id
         case originalLanguage = "original_language"
         case originalTitle = "original_title"
         case overview, popularity
         case posterPath = "poster_path"
         case releaseDate = "release_date"
         case title, video
         case voteAverage = "vote_average"
         case voteCount = "vote_count"
     }
}

struct FavResp: Codable {
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}


extension MovieModel{
    

    static let example1 = MovieModel(adult: false, backdropPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg",posterPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg", genreIDS: [1054], id: 1, originalLanguage: "en", originalTitle: "The Batman", overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler. In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler. In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler. In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler. In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler", popularity: 8.5, releaseDate: "2022-03-01", title: "The Batman", video: false, voteAverage: 7.8, voteCount: 859)
    static let example2 = MovieModel(adult: false, backdropPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg",posterPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg", genreIDS: [1054], id: 2, originalLanguage: "en", originalTitle: "The Batman", overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler", popularity: 8.5, releaseDate: "2022-03-01", title: "The Batman", video: false, voteAverage: 7.8, voteCount: 859)
    static let example3 = MovieModel(adult: false, backdropPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg",posterPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg", genreIDS: [1054], id: 3, originalLanguage: "en", originalTitle: "The Batman", overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler", popularity: 8.5, releaseDate: "2022-03-01", title: "The Batman", video: false, voteAverage: 7.8, voteCount: 859)
    static let example4 = MovieModel(adult: false, backdropPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg",posterPath: "/74xTEgt7R36Fpooo50r9T25onhq.jpg", genreIDS: [1054], id: 4, originalLanguage: "en", originalTitle: "The Batman", overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler", popularity: 8.5, releaseDate: "2022-03-01", title: "The Batman", video: false, voteAverage: 7.8, voteCount: 859)
}
