//
//  AuthNetworkService.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import FirebaseAuth

final class AuthNetworkService {
    static let shared = AuthNetworkService()
    
    private init () {
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
