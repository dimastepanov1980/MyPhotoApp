//
//  RootScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/28/23.
//

import SwiftUI

struct RootScreenView: View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    @Binding var showAuthenticationView: Bool
    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    
 
    var body: some View {
        userTypePageHub(userType: user.userType)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showAuthenticationView) {
                AuthenticationScreenView(with: AuthenticationScreenViewModel(), showAuthenticationView: $showAuthenticationView)
            }
    }
    
    @ViewBuilder
    func userTypePageHub(userType: Constants.UserType) -> some View {
            switch userType {
            case .author:
                ViewFactory.viewForDestination(.AuthorHubPageView, showAuthenticationView: $showAuthenticationView)
            case .customer:
                ViewFactory.viewForDestination(.CustomerPageHubView, showAuthenticationView: $showAuthenticationView)
            case .unspecified:
                ViewFactory.viewForDestination(.CustomerPageHubView, showAuthenticationView: $showAuthenticationView)
            }
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView(showAuthenticationView: .constant(false))
    }
}
