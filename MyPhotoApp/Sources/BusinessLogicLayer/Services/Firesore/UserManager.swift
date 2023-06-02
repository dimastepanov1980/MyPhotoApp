//
//  UserManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/29/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct UserOrders: Codable {
    let id: String
    let location: String?
    let name: String?
    let instagramLink: String?
    let price: Int?
    let description: String?
    let date: Date?
    let duration: String?
    let imageUrl: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.price = try container.decodeIfPresent(Int.self, forKey: .price)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
    
    init(order: MainOrderModel) {
        self.id = order.id
        self.location = order.place
        self.name = order.name
        self.instagramLink = order.instagramLink
        self.price = order.price
        self.description = order.description
        self.date = order.date
        self.duration = order.duration
        self.imageUrl = order.imageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case location = "location"
        case name = "name"
        case instagramLink = "instagram_link"
        case price = "price"
        case description = "description"
        case date = "date"
        case duration = "duration"
        case imageUrl = "image_url"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.location, forKey: .location)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.duration, forKey: .duration)
        try container.encodeIfPresent(self.imageUrl, forKey: .imageUrl)
    }
    
    init(order: OrderModel) {
        self.id = order.orderId
        self.location = order.location
        self.name = order.name
        self.instagramLink = order.instagramLink
        self.price = order.price
        self.description = order.description
        self.date = order.date
        self.duration = order.duration
        self.imageUrl = order.imageUrl
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
        userDocument(userId: userId).collection("orders")
    }
    private func userOrderDocument(userId: String, orderId: String) -> DocumentReference {
        userOrderCollection(userId: userId).document(orderId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
   
//    func addNewOrder(userId: String, order: UserOrders) async throws {
//        try userOrderDocument(userId: userId).setData(from: order, merge: false)
//    }
    
    func addNewOrder(userId: String, order: UserOrders) async throws {
        let document = userOrderCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            UserOrders.CodingKeys.id.rawValue : documentId,
            UserOrders.CodingKeys.location.rawValue : order.location ?? "",
            UserOrders.CodingKeys.name.rawValue : order.name ?? "",
            UserOrders.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            UserOrders.CodingKeys.price.rawValue : order.price ?? 0,
            UserOrders.CodingKeys.description.rawValue : order.description  ?? "",
            UserOrders.CodingKeys.date.rawValue : order.date ?? Timestamp(),
            UserOrders.CodingKeys.duration.rawValue : order.duration ?? "",
            UserOrders.CodingKeys.imageUrl.rawValue : order.imageUrl ?? ""
        ]
            try await document.setData(data, merge: false)
    }
    
    func removeOrder(userId: String, order: UserOrders) async throws {
        try await userOrderDocument (userId: userId, orderId: order.id).delete()
    }
    
    func getAllOrders(userId: String) async throws -> [UserOrders] {
        try await userOrderCollection(userId: userId).getDocuments(as: UserOrders.self)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
}


extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
}
