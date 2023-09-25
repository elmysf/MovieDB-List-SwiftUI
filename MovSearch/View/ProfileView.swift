//
//  ProfileView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var movieVM: MoviesViewModel
    @EnvironmentObject private var networkVM: NetworkViewModel
    
    @State var noUserLogged: Bool = true
    
    var body: some View {
        ZStack{
            
            switch noUserLogged{
                
            case true:
                if networkVM.noWifinoCelularData{
                    VStack{
                        Text("Activate mobile data or Wifi")
                            .multilineTextAlignment(.center)
                        ProgressView()
                            .padding()
                }
                } else if userVM.isLoading{
                    ProgressView("Loading...")
                        .progressViewStyle(CustomProgressViewStyle())
                }else {
                    LoginView()
                }
                
            case false:
                if userVM.isLoading{
                    ProgressView("Loading user...")
                        .progressViewStyle(CustomProgressViewStyle())
                    
                } else if userVM.user != nil {
                    UserView(user: userVM.user!)
                        .onAppear {
                            Task{
                                await movieVM.fetchFavoritesMovies(accID: "\(userVM.user!.id)")
                            }
                        }

                }else{
                    VStack{
                        Text("Your user could not be loaded")
                            .padding()
                        Button("Recharge"){
                            Task{
                                await userVM.getUserInfo()
                                guard userVM.user != nil else {return}
                                await movieVM.fetchFavoritesMovies(accID: "\(userVM.user!.id)")
                                
                            }
                        }.disabled(userVM.isLoading)
                    }
                }
            }

        }
        
        .onAppear(perform: {
            let newValue = try? userVM.keychainM.getSessionID() == ""
            if newValue != nil{
                noUserLogged = newValue!
            }

        })
        .onChange(of: try? userVM.keychainM.getSessionID() == "", perform: { newValue in

            if newValue != nil{
                withAnimation {
                    noUserLogged = newValue!
                }
             
            }
        })
    }
}
