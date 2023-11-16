//
//  AuthNetworkService.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthNetworkService {

    static let shared = AuthNetworkService()
    
    private init() {}
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> UserDataModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return UserDataModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> UserDataModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return UserDataModel(user: authDataResult.user)
    }
    func deleteUser(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        guard let userEmail = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
        try await user.reauthenticate(with: credential)
        try await user.delete()
    }
    
    func getAuthenticationUser() throws -> UserDataModel {
       guard let user = Auth.auth().currentUser else {
           throw URLError(.badServerResponse)
        }
        return UserDataModel(user: user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
