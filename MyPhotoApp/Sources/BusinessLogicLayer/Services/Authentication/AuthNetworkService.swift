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
// TODO: Заменить синглтон на DI
    static let shared = AuthNetworkService()
    
    private init() {}
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticationUser() throws -> AuthDataResultModel {
       guard let user = Auth.auth().currentUser else {
           throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        print("signOut")
    }
}
