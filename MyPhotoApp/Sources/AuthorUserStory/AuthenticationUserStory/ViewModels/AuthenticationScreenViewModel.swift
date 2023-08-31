//
//  AuthenticationScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation

@MainActor
final class AuthenticationScreenViewModel: AuthenticationScreenViewModelType {
    
    @Published var signInEmail = ""
    @Published var signInPassword = ""
    @Published var signUpEmail = ""
    @Published var signUpPassword = ""
    @Published var errorMessage = ""
    
    func setSignInEmail(_ signInEmail: String) {
        self.signInEmail = signInEmail
    }
    func setSignInPassword(_ signInPassword: String) {
        self.signInPassword = signInPassword
    }
    func registrationUser() async throws {
        guard !signInEmail.isEmpty, !signInPassword.isEmpty else {
            print("No found Email or Password in Sign In")
            return
        }
        let authDataResult = try await AuthNetworkService.shared.createUser(email: signInEmail, password: signInPassword)
        let user = DBUserModel(auth: authDataResult) 
        try await UserManager.shared.createNewUser(user: user)
    }
    func setSignUpEmail(_ signUpEmail: String) {
        self.signUpEmail = signUpEmail
    }
    func setSignUpPassword(_ signUpPassword: String) {
        self.signUpPassword = signUpPassword
    }
    func loginUser() async throws {
        guard !signUpEmail.isEmpty, !signUpPassword.isEmpty else {
            print("No found Email or Password in Login")
            return
        }
        try await AuthNetworkService.shared.signInUser(email: signUpEmail, password: signUpPassword)
    }
    
    func resetPassword() async throws {
        do {
            try await AuthNetworkService.shared.resetPassword(email: signUpEmail)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
