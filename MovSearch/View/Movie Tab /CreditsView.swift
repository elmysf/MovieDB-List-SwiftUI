//
//  CreditsView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI
import NukeUI

struct CreditsView: View {
    let directors: [Cast2]
    let producers: [Cast2]
    let cast: [Cast2]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                LazyHStack(alignment:.top){
                    
                    PeopleView(people: directors, type: .Director)
                    PeopleView(people: producers, type: .Producer)
                }
                LazyHStack(alignment: .top){
                    PeopleView(people: cast, type: .Cast)
                    
                }
                
            }.padding(.vertical)
        }
    }
}

struct PeopleView: View {
    
    let people: [Cast2]
    let type: TypePerson
    @EnvironmentObject private var networkVM: NetworkViewModel
    var body: some View{
        ForEach(people, id:\.identy){ person in
            VStack{
                LazyImage(source: Constants.ImageFetch.base_url+Constants.ImageFetch.size500+(person.profilePath ?? "https://www.gravatar.com/avatar/"), resizingMode: .aspectFill)
                    .onCompletion(Constants.onCompletionLazyImage(networkVM: networkVM))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 3)
                    .animation(nil)
                    .frame(width: 100, height: 100)
                Text(person.name).italic()
                if type == .Cast{
                    Text(person.gender == 1 ? "Actress" : "Actor").bold()
                    Text("(\(person.character ?? "Unknown"))").bold().italic()
                }else if type == .Director{
                    Text(person.gender == 1 ? "Director" : "Director").bold()
                }else{
                    Text(person.gender == 1 ? "Producer" : "Producer").bold()
                }
                
            }
            .frame(width: 150)
            
        }
    }
    
}

enum TypePerson: Equatable {
    case Director, Producer, Cast
}

