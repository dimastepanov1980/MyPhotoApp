//
//  RootScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/28/23.
//

import SwiftUI

struct RootScreenView: View {
    @State private var showAuthenticationView: Bool = true
    @State private var userIsCustomer: Bool = true
    @State var path = NavigationPath()

    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    var body: some View {
        NavigationStack(path: $path){
            ZStack {
                if !showAuthenticationView {
                    if !userIsCustomer {
                        AuthorHubPageView(showAuthenticationView: $showAuthenticationView, path: $path)
                    } else {
                        CustomerPageHubView(showAuthenticationView: $showAuthenticationView, path: $path)
                    }
                }
            }
        }
        .sheet(isPresented: $showAuthenticationView, content: {
            AuthenticationScreenView(with: AuthenticationScreenViewModel(showAuthenticationView: $showAuthenticationView, userIsCustomer: $userIsCustomer), showAuthenticationView: $showAuthenticationView)
        })

    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
