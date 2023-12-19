//
//  AuthenticationScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import SwiftUI


@MainActor
final class AuthenticationScreenViewModel: AuthenticationScreenViewModelType {
    
    @Published var custmerEmail = ""
    @Published var custmerPassword = ""
    @Published var authorEmail = ""
    @Published var authorPassword = ""
    @Published var custmerErrorMessage = ""
    @Published var authorErrorMessage = ""
    
    func setCustmerEmail(_ custmerEmail: String) {
        self.custmerEmail = custmerEmail
    }
    func setCustmerPassword(_ custmerPassword: String) {
        self.custmerPassword = custmerPassword
    }
    func authenticationCustomer() async throws {
        guard !custmerEmail.isEmpty, !custmerPassword.isEmpty else {
            print("No found Email or Password")
            return
        }
        
        do {
            try await AuthNetworkService.shared.signInUser(email: custmerEmail, password: custmerPassword)
//            self.userIsCustomer = try await getUserType()
        } catch {
            let authUserResult = try await AuthNetworkService.shared.createUser(email: custmerEmail, password: custmerPassword)
            let dbUser = DBUserModel(auth: authUserResult, userType: "customer", firstName: "", secondName: "", instagramLink: "", phone: "", avatarUser: "", setPortfolio: false)
            try await UserManager.shared.createNewCustomer(user: dbUser)
        }
    }
    
    func getUserType() async throws -> Bool {
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
        
        return user.userType == "customer"
    }
    
    func setAuthorEmail(_ authorPassword: String) {
        self.authorEmail = authorPassword
    }
    func setAuthorPassword(_ authorPassword: String) {
        self.authorPassword = authorPassword
    }
    func authenticationAuthor() async throws {
        guard !authorEmail.isEmpty, !authorPassword.isEmpty else {
            print("No found Email or Password")
            return
        }
        
        do {
            try await AuthNetworkService.shared.signInUser(email: authorEmail, password: authorPassword)
//            self.userIsCustomer = try await getUserType()
        } catch {
            let authUserResult = try await AuthNetworkService.shared.createUser(email: authorEmail, password: authorPassword)
            let dbUser = DBUserModel(auth: authUserResult, userType: "author", firstName: "", secondName: "", instagramLink: "", phone: "", avatarUser: "", setPortfolio: false)
            try await UserManager.shared.createNewAuthor(author: dbUser)
        }
    }
    func resetPassword() async throws {
        do {
            try await AuthNetworkService.shared.resetPassword(email: authorEmail)
        } catch {
            self.custmerErrorMessage = error.localizedDescription
        }
    }
}
