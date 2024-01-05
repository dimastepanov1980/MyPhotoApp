//
//  RootScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/12/23.
//

import SwiftUI

@MainActor
final class UserTypeService: ObservableObject {

    @Published var userType: Constants.UserType = .unspecified
    @Published var user: DBUserModel?
    @Published var userID: String?
    
    func getUserType() async {
        do {
            let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
            let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
            self.user = user
            self.userID = userDataResult.uid
            
            switch user.userType {
            case "author":
                userType = .author
            case "customer":
                userType = .customer
            default:
                userType = .unspecified
            }
        } catch {
            print("UserTypeService: Error fetching user type: \(error.localizedDescription)")
        }
    }
}

