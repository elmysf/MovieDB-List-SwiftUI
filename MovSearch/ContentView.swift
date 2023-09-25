//
//  ContentView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import SwiftUI

enum Tab: String {
    case Home
    case Profile
    case search
}

struct ContentView: View {
    
    @EnvironmentObject private var movieVM: MoviesViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var networkVM: NetworkViewModel
    @AppStorage("selectedTab") private var selectedTab: Tab = .Home
    
    @AppStorage("firsTimeInApp") private var firsTimeInApp: Bool = true
    
    
    @State private var noInternet = false
    
    var body: some View {
        GeometryReader{ g in
            TabView(selection: $selectedTab){
                        MovieView()
                    .tabItem {
                        Image(systemName: "film")
                        Text("Movie")
                    }
                    .tag(Tab.Home)
                    .alert(isPresented: $movieVM.showAlert) {
                        Alert(title: Text("Information"),
                              message: Text(movieVM.alertMessage)
                        )
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(Tab.search)
                    .alert(isPresented: $movieVM.showAlert) {
                        Alert(title: Text("Information"), message: Text(movieVM.alertMessage))
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(Tab.Profile)
                    .alert(isPresented: $userVM.showAlert) {
                        Alert(title: Text("Information"), message: Text(userVM.alertMessage))
                    }
               
            }
            .isPortrait(g.size.height > g.size.width)
            .onAppear {
                if firsTimeInApp {
                    Task{
                         await firstTask()
                         firsTimeInApp = false
                     }
                }else{
                    Task {
                        await getUser()
                    }

                }

            }
            .offset(y: noInternet ? -30 : 0)
            
            NoInternetBannerView(status: noInternet, geometryProxy: g)
            
        }
        .onReceive(networkVM.$noInternet){ int in
            withAnimation {
                noInternet = int
            }
        }
    }
}


extension ContentView{
    
    private func firstTask() async {
        if networkVM.noWifinoCelularData == false {
    
            print("First time in the APP")
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
                taskgroup.addTask {
                    await getUser()
                }
            })
        }else{
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await firstTask()
        }
    }

    func getUser() async {
            let isUserLoggedIn = try?  userVM.keychainM.getSessionID() != ""
            guard isUserLoggedIn != nil, networkVM.noInternet == false else{return}
            if  userVM.user == nil && isUserLoggedIn!  {
                    await userVM.getUserInfo()
                    guard userVM.user != nil else {return}
                    await movieVM.fetchFavoritesMovies(accID: "\(userVM.user!.id)")
            }
    }
}
