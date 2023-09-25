//
//  PersistenceController2.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import CoreData
import SwiftUI

final class PersistenceController2 {
    static let shared = PersistenceController2()
    
    private init(){}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieCDModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
}


extension PersistenceController2{

    func importMovies(from movies: [FullMovieModel], category: MovieCategory) async throws {
        
        let backgroundContext = newTaskContext()
        
        if #available(iOS 15.0, *) {
            try await backgroundContext.perform{
                
                for movi in movies{
                    let movie = MovieModelCD(context: backgroundContext)
                    movie.genres = movi.genres.first?.name ?? "Unknown"
                    movie.voteCount = Int64(movi.voteCount)
                    movie.voteAverage = movi.voteAverage
                    movie.releaseDate = movi.releaseDate
                    movie.overview = movi.overview
                    movie.posterPath = movi.posterPath
                    movie.popularity = movi.popularity
                    movie.runtime = Int64(movi.runtime ?? 0)
                    movie.id = Int64(movi.id)
                    movie.budget = Int64(movi.budget)
                    movie.title = movi.title
                    movie.revenue = Int64(movi.revenue)
                    movie.tagline = movi.tagline
                    movie.credits  = movi.credits
                    movie.category = category
                }
                
                if backgroundContext.hasChanges{
                    do {
                        try backgroundContext.save()
                        print("Successfully saved movies")
                    } catch  {
                        throw CoreDataError.savingError
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
}

extension MovieModelCD {
    
    var credits : Credits {
        get {
            return (try? JSONDecoder().decode(Credits.self, from: Data(credits_!.utf8))) ?? Credits(cast: [], crew: [])
        }
        set {
           do {
               let crewTest = try JSONEncoder().encode(newValue)
               credits_ = String(data: crewTest, encoding:.utf8)!
           } catch { credits_ = "" }
        }
    }
    
    var directors: [Cast2] {
        credits.crew.filter { $0.job!.lowercased() == "director" }
    }
    
    var producers: [Cast2] {
        credits.crew.filter { $0.job!.lowercased() == "producer" }
    }
    
    var cast:[Cast2]{
        credits.cast
    }
    
    var category: MovieCategory {
        get {
            MovieCategory(rawValue: category_!) ?? .unknown
        }
        set {
            category_ = newValue.rawValue
        }
    }
    
    
    
}

enum MovieCategory: String {
    case popular, search, topRated, unknown, nowPlaying, upcoming
}
