//
//  SignInSignUpViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/19/23.
//

import Foundation

@MainActor
final class SignInSignUpViewModel: SignInSignUpViewModelType {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var userType: String = ""
    
    func signIn() async throws {
//        do {
//            print(email)
            try await AuthNetworkService.shared.signInUser(email: email, password: password)
            let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
            let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
            self.userType = user.userType ?? "customer"
//        } catch  {
//            print(error.localizedDescription)
//            self.errorMessage = error.localizedDescription
//        }
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No found Email or Password")
            return
        }
        let authUserResult = try await AuthNetworkService.shared.createUser(email: email, password: password)
        let dbUser = DBUserModel(auth: authUserResult, userType: "customer", firstName: "", secondName: "", instagramLink: "", phone: "", avatarUser: "", setPortfolio: false)
        try await UserManager.shared.createNewUser(author: dbUser)
        
    }
    
    func resetPassword() async throws {
        do {
            try await AuthNetworkService.shared.resetPassword(email: email)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

enum authType {
    case signIn
    case signUp
}
