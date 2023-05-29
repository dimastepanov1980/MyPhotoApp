//
//  UserManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/29/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let description: String?
    let email: String?
    let photoURL: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String : Any] = [
            "user_id" : auth.uid,
            "description" : auth.description,
        ]
        if let photoURL = auth.photoURL {
            userData ["photo_url"] = photoURL
        }
        
        if let email = auth.email {
            userData ["email"] = email
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
    let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let description = data["description"] as? String
        let email = data["email"] as? String
        let photoURL = data["photoURL"] as? String
        
        return DBUser(userId: userId, description: description, email: email, photoURL: photoURL)
    }
}
