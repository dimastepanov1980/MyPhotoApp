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
    @Published var token: String?
    
    func getUserType() async {
        guard let currentToken = UserDefaults.standard.string(forKey:"fcmToken") else {
            return
        }
        do {
            let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
            let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
            self.user = user
            self.userID = userDataResult.uid
            if user.token != nil && currentToken == user.token {
                self.token = user.token
            } else {
                self.token = currentToken
                try await UserManager.shared.updateToken(userId: userDataResult.uid, token: currentToken)
            }
            
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

