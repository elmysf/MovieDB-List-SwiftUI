//
//  ZoomedImage.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import SwiftUI
import NukeUI

struct ZoomedImage: View {
    let url: String
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            LazyImage(source: url, resizingMode: .aspectFit)
                .zoomable()
            SheetCloseButton()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
        }
        
    }
}
