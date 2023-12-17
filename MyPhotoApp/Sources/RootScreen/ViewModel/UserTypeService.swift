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

    func getUserType() async {
        do {
            let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
            let user = try await UserManager.shared.getUser(userId: userDataResult.uid)

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
    
    func setUserType() async throws {
        //
    }

}

