//
//  RootScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/28/23.
//

import SwiftUI

struct RootScreenView: View {
    @State private var showSignInView: Bool = false
    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    @State private var showCostomerZone: Bool = false
    var body: some View {
        Group {
            if !showCostomerZone {
                CustomerPageHubView(showCostomerZone: $showCostomerZone)
                 
            } else {
                AuthorHubPageView(showSignInView: $showSignInView, showCostomerZone: $showCostomerZone)
            }
        }
        .onAppear{
            let authUser = try? AuthNetworkService.shared.getAuthenticationUser()
            self.showSignInView = authUser == nil
        }.sheet(isPresented: $showSignInView, content: {
            AuthenticationScreenView(with: AuthenticationScreenViewModel(), showSignInView: $showSignInView)

        })
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
