//
//  SearchView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var movieVM: MoviesViewModel
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""
    @State private var enableDismissKeyboard:Bool = false
    @State private var searchedMovies: [FullMovieModel] = []
    var body: some View {
        NavigationView {
            
            List {
                SearchBarUIKit(text: $searchText, placeholder: "Search Film", search: {
                    Task{
                        await movieVM.fetchMovies(of:.searchMovie, search:searchText)
                    }
                })
                if movieVM.isLoading{
                    ProgressView("Seeking...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                ForEach(searchedMovies){ movie in
                    
                    NavigationLink(movie.title, destination: DetailMovieView(movie: movie))
                    
                    
                }
            }
            .delayedAnimation()
            .listStyle(.insetGrouped)
            .navigationTitle("Search")
            
        }
                .gesture(
                    TapGesture()
                        .onEnded({ _ in
                            guard enableDismissKeyboard else{return}
                            UIApplication.shared.endEditing()
                        }),
                    including: enableDismissKeyboard ? .gesture : .subviews
                )
        .onReceive(NotificationCenter.default.publisher(for: UIWindow.keyboardWillShowNotification), perform: { _ in
            enableDismissKeyboard = true
        })
        .onReceive(NotificationCenter.default.publisher(for: UIWindow.keyboardWillHideNotification), perform: { _ in
            enableDismissKeyboard = false
        })
        .onReceive(movieVM.$isLoading.dropFirst(3)) { isloading in
            isLoading = isloading
            
        }
        .onReceive(movieVM.$searchedMovies) { movies in
            searchedMovies = movies
        }
    }
}
