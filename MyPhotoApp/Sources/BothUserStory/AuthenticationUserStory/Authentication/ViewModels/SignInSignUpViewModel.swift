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
    
    func signIn() async throws {
        do {
            try await AuthNetworkService.shared.signInUser(email: email, password: password)
        } catch  {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No found Email or Password")
            return
        }
        
        do {
            let authUserResult = try await AuthNetworkService.shared.createUser(email: email, password: password)
            let dbUser = DBUserModel(auth: authUserResult, userType: "author", firstName: "", secondName: "", instagramLink: "", phone: "", avatarUser: "", setPortfolio: false)
            try await UserManager.shared.createNewAuthor(author: dbUser)
        } catch {
                self.errorMessage = error.localizedDescription
            }
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
