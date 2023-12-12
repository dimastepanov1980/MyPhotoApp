//
//  RootScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/28/23.
//

import SwiftUI

struct RootScreenView: View {
    @EnvironmentObject var router: Router<Views>
    
    @Binding var showAuthenticationView: Bool
    @State private var userIsCustomer: Bool = true
    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    
    var body: some View {
            ZStack {
                if !showAuthenticationView {
                    if !userIsCustomer {
                        AuthorHubPageView(showAuthenticationView: $showAuthenticationView)
                    } else {
                        CustomerPageHubView(showAuthenticationView: $showAuthenticationView)
                    }
                }
            }
        .sheet(isPresented: $showAuthenticationView) {
            NavigationStack{
                AuthenticationScreenView(with: AuthenticationScreenViewModel(showAuthenticationView: $showAuthenticationView, userIsCustomer: $userIsCustomer), showAuthenticationView: $showAuthenticationView)
            }
        }

    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView(showAuthenticationView: .constant(true))
    }
}
