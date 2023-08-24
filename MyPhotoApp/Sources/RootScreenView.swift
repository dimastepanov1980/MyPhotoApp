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
    var body: some View {
        ZStack {
            if !showSignInView {
                AuthorHubPageView(showSignInView: $showSignInView)
            }
        }
        .onAppear{
            let authUser = try? AuthNetworkService.shared.getAuthenticationUser()
            self.showSignInView = authUser == nil
        }.sheet(isPresented: $showSignInView, content: {
            AuthorizationScreenView(with: AuthorizationScreenViewModel(), showSignInView: $showSignInView)

        })
//        .fullScreenCover(isPresented: $showSignInView) {
//            NavigationStack {
//                AuthorizationScreenView(with: AuthorizationScreenViewModel(), showSignInView: $showSignInView)
//            }
//        }
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
