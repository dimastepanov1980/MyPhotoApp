//
//  AuthScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation

final class AuthScreenViewModel: AuthScreenViewModelType {
    @Published var signInEmail = ""
    @Published var signInPassword = ""
    @Published var signUpEmail = ""
    @Published var signUpPassword = ""
    
    func setSignInEmail(_ signInEmail: String) {
        self.signInEmail = signInEmail
    }
    func setSignInPassword(_ signInPassword: String) {
        self.signInPassword = signInPassword
    }
    func signIn() async throws {
        guard !signInEmail.isEmpty, !signInPassword.isEmpty else {
            print("No found Email or Password in Sign In")
            return
        }
        try await AuthNetworkService.shared.createUser(email: signInEmail, password: signInPassword)
    }
    
    func setSignUpEmail(_ signUpEmail: String) {
        self.signUpEmail = signUpEmail
    }
    func setSignUpPassword(_ signUpPassword: String) {
        self.signUpPassword = signUpPassword
    }
    func signUp() {
        //
    }
}
