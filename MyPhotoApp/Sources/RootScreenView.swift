//
//  RootScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/28/23.
//

import SwiftUI

struct RootScreenView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        ZStack {
            //if showSignInView {
                MainScreenView(with: MainScreenViewModel(), showSignInView: $showSignInView)
            //}
        }
        .onAppear{
            let authUser = try? AuthNetworkService.shared.getAuthenticationUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthScreenView(with: AuthScreenViewModel(), showSignInView: $showSignInView)
            }
        }
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
