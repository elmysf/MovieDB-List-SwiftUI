//
//  MovieCardView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI
import NukeUI

struct MovieCardView: View {
    @EnvironmentObject private var networkVM: NetworkViewModel
    let movie: MovieModelCD
    
    init(with movie: MovieModelCD) {
        self.movie = movie
    }
    var body: some View {
        LazyImage(source: Constants.ImageFetch.base_url+Constants.ImageFetch.size500+movie.posterPath!, resizingMode: .aspectFill)
            .onCompletion(Constants.onCompletionLazyImage(networkVM: networkVM))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
            .animation(nil)
        
        
    }
}
