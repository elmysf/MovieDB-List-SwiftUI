//
//  MoviesView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI


struct MoviesView: View {
    @EnvironmentObject private var movieVM: MoviesViewModel
    let newMovies: FetchedResults<MovieModelCD>
    let popularMovies: FetchedResults<MovieModelCD>
    let topRatedMovies:FetchedResults<MovieModelCD>
    let upcomingMovies:FetchedResults<MovieModelCD>
    var body: some View {
        
        GeometryReader { g in
            ScrollView {
                VStack(spacing:0) {
                    
                    VStack(spacing:10) {
                        Text("Upcoming Movie")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        MoviesCarrouselView(movies: upcomingMovies, alto: g.size.height)
                        
                        
                    }.padding()
                    
                    VStack(spacing:10) {
                        Text("Nowplaying Movie")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        MoviesCarrouselView(movies: newMovies, alto: g.size.height)
                        
                        
                    }.padding()
                    
                    VStack(spacing:10) {
                        Text("Most popular")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        MoviesCarrouselView(movies: popularMovies, alto: g.size.height)
                        
                        
                    }.padding()
                    
                    
                    VStack(spacing:10){
                        Text("Top rated movies")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        MoviesCarrouselView(movies: topRatedMovies, alto: g.size.height)
                        
                    }.padding()
                }
                .pullToRefresh {
                    await movieVM.fetchMovies(of: .popularMovies)
                    await movieVM.fetchMovies(of: .topRatedMovies)
                    await movieVM.fetchMovies(of: .nowPlayingMovies)
                    await movieVM.fetchMovies(of: .upcomingMovies)
                }
            }
        }
        
        
    }
}

