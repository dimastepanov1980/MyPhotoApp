//
//  RootScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/28/23.
//

import SwiftUI

struct RootScreenView: View {
//    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    
 
    var body: some View {
        userTypePageHub(userType: user.userType)
            .navigationBarBackButtonHidden(true)
            .onAppear {
              UNUserNotificationCenter.current().setBadgeCount(0)
            }
    }
    
    
    @ViewBuilder
    func userTypePageHub(userType: Constants.UserType) -> some View {
            switch userType {
            case .author:
                ViewFactory.viewForDestination(.AuthorHubPageView)
            case .customer:
                ViewFactory.viewForDestination(.CustomerPageHubView)
            case .unspecified:
                ViewFactory.viewForDestination(.CustomerPageHubView)
            }
    }
}

struct RootScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenView()
    }
}
