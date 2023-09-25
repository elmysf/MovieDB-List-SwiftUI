//
//  UserView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI
import NukeUI


struct UserView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var movieVM: MoviesViewModel
    @EnvironmentObject private var networkVM: NetworkViewModel
    let user: UserModel
    
    var body: some View {
        
        GeometryReader { g in
            VStack{
                VStack{
                    LazyImage(source: Constants.gravatarURL + user.avatar.gravatar.hash, resizingMode: .aspectFit)
                        .onCompletion(Constants.onCompletionLazyImage(networkVM: networkVM))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 4))
                        .shadow(radius: 5)
                        .frame(width: 100, height: 100)
                    Text("Welcome, \(user.username)")
                        .padding(.top,5)
                    Button("Log Out"){
                        Task{
                            await userVM.logOut()
                        }
                    }.padding(5)
                    Divider()
                    Text("Favorite movies")
                        .font(.title)
                        .bold()
                    
                }.frame(width: g.size.width, height: g.size.height*0.4)
                
                if movieVM.favoritesMovies.count != 0 {
                    List(movieVM.favoritesMovies){ movie in
                        HStack{
                            Text(movie.title)
                        }.frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .center)
                        
                    }.padding(.top,5)
                        .frame(width: g.size.width, height: g.size.height*0.6)
                        .listStyle(.plain)
                }else if movieVM.isLoading {
                    ProgressView()
                        .padding()
                }else{
                    if movieVM.isLoading {
                        ProgressView()
                            .padding()
                    }
                    Button("Reload"){
                        Task{
                            await movieVM.fetchFavoritesMovies(accID: "\(userVM.user!.id)")
                        }
                        
                    }.padding()
                        .disabled(movieVM.isLoading)
                }
                
            }
        }.animation(.default)
        .padding()
    }
}
