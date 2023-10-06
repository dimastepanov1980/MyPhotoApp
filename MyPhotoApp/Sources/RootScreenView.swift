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
            } else {
                Color.red
            }
        }
        .onAppear {
            Task {
                do {
                    let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
                    let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
                    print("Get User Info \(user)")
                    if user.userType == "customer" {
                        self.userIsCustomer = true
                        self.showAuthenticationView = false
                        print("user is customer, it is customer - \(userIsCustomer): \(user)")
                        
                    } else {
                        self.userIsCustomer = false
                        self.showAuthenticationView = false
                        print("user is author, it is customer  - \(userIsCustomer): \(user) ")
                    }
                } catch {
                    print("Error: \(error)")
                    self.showAuthenticationView = true
                }
            }
        }
        .sheet(isPresented: $showAuthenticationView, content: {
            AuthenticationScreenView(with: AuthenticationScreenViewModel(), showAuthenticationView: $showAuthenticationView, userIsCustomer: $userIsCustomer)

        })
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
