//
//  NoInternetBannerView.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import SwiftUI

struct NoInternetBannerView: View {
    let status:Bool
    let geometryProxy: GeometryProxy
    var body: some View{
        HStack{
            Image(systemName: "wifi.slash")
            Text("No Internet")
                .font(.footnote)
                .bold()
        }
        .frame(width:geometryProxy.size.width,height: geometryProxy.safeAreaInsets.bottom+30)
        .background(Color.orange)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .offset(y: status ? geometryProxy.safeAreaInsets.bottom : (geometryProxy.safeAreaInsets.bottom+30)*2)
        
    }
}
