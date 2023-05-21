//
//  AuthScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation


final class AuthScreenViewModel: AuthScreenViewModelType {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or Password Found")
            return
        }
        Task {
            do {
                let returnedUserData = try await AuthNetworkService.shared.createUser(email: email, password: password)
                print("Seccess")
                print(returnedUserData)
            } catch {
                print("error \(error.localizedDescription)")
            }
        }
    }
}
