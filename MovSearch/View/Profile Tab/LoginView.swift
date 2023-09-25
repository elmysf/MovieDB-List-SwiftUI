//
//  LoginView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userVM: UserViewModel
    var body: some View {
        VStack{
            Text("Login to your TMDB account")
                .padding()
            Button("Login") {
                
                Task{
                    try await  userVM.LogIn()
                }
                
            }.disabled(userVM.isLoading)
            
        }
    }
}
