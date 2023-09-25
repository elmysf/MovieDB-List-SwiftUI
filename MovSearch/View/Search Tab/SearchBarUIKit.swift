//
//  SearchBarUIKit.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI

struct SearchBarUIKit: UIViewRepresentable {
    
    @Binding var text: String
    let placeholder: String
    var search: ()-> Void
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = placeholder
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, UISearchBarDelegate {
     var parent: SearchBarUIKit

     init(_ searchBar: SearchBarUIKit) {
         parent = searchBar
     }

     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         parent.text = searchText
     }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        parent.search()
        UIApplication.shared.endEditing()
    }
 }
