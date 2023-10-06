//
//  AuthenticationScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation

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
        } catch {
            let authUserResult = try await AuthNetworkService.shared.createUser(email: custmerEmail, password: custmerPassword)
            let dbUser = DBUserModel(auth: authUserResult, userType: "customer")
            try await UserManager.shared.createNewCustomer(user: dbUser)
        }
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
        } catch {
            let authUserResult = try await AuthNetworkService.shared.createUser(email: authorEmail, password: authorPassword)
            let dbUser = DBUserModel(auth: authUserResult, userType: "author")
            try await UserManager.shared.createNewCustomer(user: dbUser)
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
