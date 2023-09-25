//
//  MovieView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import SwiftUI

struct MovieView: View {
    
    @EnvironmentObject private var movieVM: MoviesViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var networkVM: NetworkViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "voteAverage", ascending: false)],predicate: NSPredicate(format: "category_ == %@", MovieCategory.popular.rawValue) ) private var popularMovies: FetchedResults<MovieModelCD>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "voteAverage", ascending: false)],predicate: NSPredicate(format: "category_ == %@", MovieCategory.topRated.rawValue)) private var topRatedMovies: FetchedResults<MovieModelCD>
 
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "voteAverage", ascending: false)],predicate: NSPredicate(format: "category_ == %@", MovieCategory.nowPlaying.rawValue)) private var newMovies: FetchedResults<MovieModelCD>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "voteAverage", ascending: false)],predicate: NSPredicate(format: "category_ == %@", MovieCategory.upcoming.rawValue)) private var upcomingMovies: FetchedResults<MovieModelCD>
    
    @State private var noWifinoCelularData: Bool = false
    @State private var noInternet: Bool = false
    @State private var isMoviesEmpty: Bool = true
    
    var body: some View {
        
        NavigationView{
           
            MoviesView(newMovies: newMovies, popularMovies: popularMovies, topRatedMovies: topRatedMovies, upcomingMovies: upcomingMovies)

                    .navigationTitle("The Movie DB")
            
        }.navigationViewStyle(.stack)
        
    
        .onReceive(networkVM.$noWifinoCelularData) { element in
            withAnimation {
                noWifinoCelularData = element
                
            }
            
        }
        .onReceive(networkVM.$noInternet) { element in
            withAnimation {
                noInternet = element
                
            }
            
        }
        .onReceive(movieVM.$movies) { element in
            withAnimation {
                isMoviesEmpty = element.isEmpty
                
            }
            
        }
    }
}

extension MovieView{
    
    private var reloadMoviesView:some View{
        VStack{
            if movieVM.isLoading{
                ProgressView().padding()
            }
            Text("The movies could not be obtained from the Internet")
            Button("Retry"){
                Task {
                    _ =  await withTaskGroup(of: Void.self, body: { taskgroup in
                        taskgroup.addTask {
                            await movieVM.fetchMovies(of: .popularMovies)
                        }
                        taskgroup.addTask {
                            await movieVM.fetchMovies(of: .topRatedMovies)
                        }
                        taskgroup.addTask {
                            await movieVM.fetchMovies(of: .nowPlayingMovies)
                        }
                        taskgroup.addTask {
                            await movieVM.fetchMovies(of: .upcomingMovies)
                        }

                    })

                }
            }.padding()
                .disabled(movieVM.isLoading)
        }
    }
}
