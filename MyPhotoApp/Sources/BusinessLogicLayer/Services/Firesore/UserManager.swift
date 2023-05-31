//
//  UserManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/29/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserOrders: Identifiable, Codable {
    let id: String
    let location: String?
    let name: String?
    let instagramLink: String?
    let price: Int?
    let description: String?
    let date: Date?
    let duration: Double?
    
    init(userOrder: OrderModel) {
        self.id = userOrder.orderId
        self.location = userOrder.location
        self.name = userOrder.name
        self.instagramLink: String?
        self.price: Int?
        self.description: String?
        self.date: Date?
        self.duration: Double
    }
}

struct DBUser: Codable {
    let userId: String
    let description: String?
    let email: String?
    let photoURL: String?
    let dateCreate: Date?
    //add updeting bool property https://youtu.be/elGMTQGRZGo?t=1062
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.description = auth.description
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreate = Date()
    }

    init(userId: String,
         description: String? = nil,
         email: String? = nil,
         photoURL: String? = nil,
         dateCreate: Date? = nil
    ){
        self.userId = userId
        self.description = description
        self.email = email
        self.photoURL = photoURL
        self.dateCreate = dateCreate
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case description = "description"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreate = "date_create"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreate = try container.decodeIfPresent(Date.self, forKey: .dateCreate)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreate, forKey: .dateCreate)
        
    }
}

final class UserManager {
    
    static let shared = UserManager()
    
    private let userCollection = Firestore.firestore().collection("users")

    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private init() {}
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    private func userOrderCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection ("orders")
    }
    private func userOrderDocument(userId: String, orderId: String) -> DocumentReference {
        userOrderCollection(userId: userId).document(orderId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
   
    
    func addUserOrder(userId: String, location: String, customerName: String) async throws {
        let document = userOrderCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            "id" : documentId,
            "date_created" : Timestamp(),
            "customer_name" : customerName,
            "location" : location
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserOrder(userId: String, orderId: String) async throws {
        try await userOrderDocument(userId: userId, orderId: orderId).delete()
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
}
