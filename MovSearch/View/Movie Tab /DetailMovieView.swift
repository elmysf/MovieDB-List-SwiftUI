//
//  DetailMovieView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI
import NukeUI
import CoreData

struct DetailMovieView: View{
    @EnvironmentObject private var movieVM: MoviesViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var networkVM: NetworkViewModel
    @State private var isFavorite: Bool = false
    @State private var noInternet: Bool = false
    @State private var showZoomedImage: Bool = false
    let movie: Any
    
    var movie2:FullMovieModel? {
        movie as? FullMovieModel
    }
    var movie3: MovieModelCD?{
        movie as? MovieModelCD
    }
    
    let sizeScreen = (width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    var body: some View {
        
        VStack(spacing:0) {

            if movie3 != nil {
                HStack(alignment: .top){
                    Text((movie2?.title ?? movie3?.title) ?? "Unknown" )
                        .font(.title)
                        .bold()
                        .padding(.leading,(sizeScreen.width)*0.15)
                        .frame(width: (sizeScreen.width)*0.85-10)
                    SheetCloseButton()
                        .frame(width: (sizeScreen.width)*0.15-10)
                    
                }.padding(.horizontal, 10)
                    .padding(.top)
                    .padding(.bottom,5)
                
            }

            ScrollView(showsIndicators: false) {
                LazyImage(source: Constants.ImageFetch.base_url+Constants.ImageFetch.size500+(movie2?.posterPath ?? movie3?.posterPath ?? "No image"), resizingMode: .aspectFit)
                    .onCompletion(Constants.onCompletionLazyImage(networkVM: networkVM))
                    .frame(width: 250, height: 250)
                    .onTapGesture {
                        showZoomedImage = true
                    }
                
                HStack {
                    Image(systemName: isFavorite ? "star.fill": "star")
                        .foregroundColor(.yellow)
                    
                    Button(isFavorite ? "Remove from favorites":"Add to favorites"){
                        Task{
                            // guard userVM.user != nil else{return}
                            isFavorite.toggle()
                            let result = await movieVM.setFavoriteMovie(accID: "\(userVM.user!.id)", idMovie: Int(movie2?.id ?? Int(movie3?.id ?? 0)), favorite: !isFavorite ? false : true)
                            
                            if !result {
                                isFavorite.toggle()
                            }
                            
                        }
                        
                    }
                }.disabled(userVM.user == nil)
                    .padding(5)
                Divider()
                VStack(alignment: .leading) {
                    
                    Text("Genre: ").bold()
                    + Text(( ( movie2?.genres.first?.name ?? movie3?.genres) ?? "Unknown"))
                    Text("Duration: ").bold() +
                    
                    Text(Double(movie2?.runtime ?? Int(movie3?.runtime ?? 0) ).asString(style: .abbreviated) )
                    
                    Text("Premiere: ").bold() + Text(movie2?.releaseDate ?? movie3?.releaseDate ?? "Date unknown")
                    
                    Text("Valuation: " ).bold() +
                    Text(String(format: "%g", movie2?.voteAverage ?? Double(movie3?.voteAverage ?? 0))+"/10 " + "(\(movie2?.voteCount ?? Int(movie3?.voteCount ?? 0) ) votes)")
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical,5)
                
                Divider()

                CreditsView(directors: movie2?.directors ?? movie3?.directors ?? [], producers: movie2?.producers ?? movie3?.producers ?? [], cast: movie2?.credits.cast ?? movie3?.cast ?? [])
                
                Divider()

                Text("Summary")
                    .font(.title3)
                    .bold()
                    .padding(.vertical,5)
                
                Text(movie2?.overview ?? movie3?.overview != "" && movie2?.overview ?? movie3?.overview != nil ? (movie2?.overview ?? movie3?.overview)! : String("Not available"))
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 10)
                
            }
            .padding(.horizontal)
            .onReceive(movieVM.$favoritesMovies){ fM in
                print("CAPTURING FAVORITES")
                isFavorite = (fM.first{ $0.id == movie2?.id ?? Int(movie3?.id ?? 0) } != nil)
                print(isFavorite)
            }
            .onReceive(networkVM.$noInternet){ int in
                print("RECIVING \(int) ONRECEIVE")
                noInternet = int
            }
        }.navigationBarTitle(movie2?.title ?? "")
            .fullScreenCover(isPresented: $showZoomedImage) {
                ZoomedImage(url: Constants.ImageFetch.base_url+Constants.ImageFetch.size500+(movie2?.posterPath ?? movie3?.posterPath ?? "No Image"))
            }
    }
}



struct SheetCloseButton:View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        
        Button("\(Image(systemName: "xmark.circle"))"){
            presentationMode.wrappedValue.dismiss()
        }.font(.system(size: 27))
        
    }
}
