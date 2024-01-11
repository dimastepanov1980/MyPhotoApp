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
    @Published var token: String?
    
    init(){
        getToken()
    }
    
    func getToken(){
        self.token = UserDefaults.standard.string(forKey:"fcmToken")
    }
    
    func signIn() async throws {
        try await AuthNetworkService.shared.signInUser(email: email, password: password)
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
        if user.token != token {
            try await UserManager.shared.updateToken(userId: userDataResult.uid, token: token ?? "")
        }
        self.userType = user.userType ?? "customer"
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No found Email or Password")
            return
        }
        let authUserResult = try await AuthNetworkService.shared.createUser(email: email, password: password)
        let dbUser = DBUserModel(auth: authUserResult, userType: "customer", firstName: "", secondName: "", instagramLink: "", phone: "", avatarUser: "", setPortfolio: false, token: token)
        print(dbUser)
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
