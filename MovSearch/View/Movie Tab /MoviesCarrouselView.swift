//
//  MoviesCarrouselView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI

struct MoviesCarrouselView<Result: RandomAccessCollection>: View where Result.Element == MovieModelCD {
    let movies: Result
    
    @EnvironmentObject private var movieVM: MoviesViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var networkVM: NetworkViewModel
    let alto: CGFloat
    @State private var movieSelected: MovieModelCD?
    
    @Environment(\.isPortrait) var isPortrait: Bool
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing:0) {
                    ForEach(movies, id:\.id){ movie in
                        MovieCardView(with: movie)
                     
                            .frame(width: isPortrait ? proxy.size.width*0.5 : proxy.size.width*0.25)
                            .padding()
                            .onTapGesture {
                                movieSelected = movie
                            }
                    }
                }.animation(.default)
            }.frame(height: proxy.size.height)
            .sheet(item: $movieSelected){ m in
                DetailMovieView(movie: m)
                   
                    .alert(isPresented: $movieVM.showAlert) {
                        Alert(title: Text("Information"),
                              message: Text(movieVM.alertMessage)
                        )
                    }
                    .environmentObject(userVM)
                    .environmentObject(movieVM)
                    .environmentObject(networkVM)
        }
        }.frame(height:alto/2)
    }
}

