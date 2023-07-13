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
    
    func createNewUser(user: DBUserModel) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
   
//    func addNewOrder(userId: String, order: UserOrders) async throws {
//        try userOrderDocument(userId: userId).setData(from: order, merge: false)
//    }
    
    func addNewOrder(userId: String, order: UserOrdersModel) async throws {
        let document = userOrderCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            UserOrdersModel.CodingKeys.id.rawValue : documentId,
            UserOrdersModel.CodingKeys.location.rawValue : order.location ?? "",
            UserOrdersModel.CodingKeys.name.rawValue : order.name ?? "",
            UserOrdersModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            UserOrdersModel.CodingKeys.price.rawValue : order.price ?? "0",
            UserOrdersModel.CodingKeys.description.rawValue : order.description  ?? "",
            UserOrdersModel.CodingKeys.date.rawValue : order.date,
            UserOrdersModel.CodingKeys.duration.rawValue : order.duration ?? "",
            UserOrdersModel.CodingKeys.imageUrl.rawValue : order.imageUrl ?? [""],
            UserOrdersModel.CodingKeys.status.rawValue : "Upcoming"
        ]
            try await document.setData(data, merge: false)
    }
    
    func updateOrder(userId: String, order: UserOrdersModel, orderId: String) async throws {
        let data: [String : Any] = [
                   UserOrdersModel.CodingKeys.location.rawValue : order.location ?? "",
                   UserOrdersModel.CodingKeys.name.rawValue : order.name ?? "",
                   UserOrdersModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
                   UserOrdersModel.CodingKeys.price.rawValue : order.price ?? "",
                   UserOrdersModel.CodingKeys.description.rawValue : order.description  ?? "",
                   UserOrdersModel.CodingKeys.date.rawValue : order.date,
                   UserOrdersModel.CodingKeys.duration.rawValue : order.duration ?? "",
                   UserOrdersModel.CodingKeys.status.rawValue : order.status ?? "Upcoming"
               ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data)
    }
    
    func updateStatus(userId: String, order: UserOrdersModel, orderId: String) async throws {
        let data: [String : Any] = [
                   UserOrdersModel.CodingKeys.status.rawValue : order.status ?? "Upcoming"
               ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data)
    }
    
    func removeOrder(userId: String, order: UserOrdersModel) async throws {
        try await userOrderDocument (userId: userId, orderId: order.id).delete()
    }
    
    func addToAvatarLink(userId: String, path: String, orderId: String) async throws {
        let data: [String : [Any]] = [
            UserOrdersModel.CodingKeys.imageUrl.rawValue : [path]
        ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data) //.setData(data, merge: true)
    }
    
    func addToImagesUrlLinks(userId: String, path: [String], orderId: String) async throws {
        try await userOrderDocument (userId: userId, orderId: orderId).updateData([UserOrdersModel.CodingKeys.imageUrl.rawValue : FieldValue.arrayUnion(path)])
    }
    
    func getAllOrders(userId: String) async throws -> [UserOrdersModel] {
        try await userOrderCollection(userId: userId).getDocuments(as: UserOrdersModel.self)
    }
    
    func getUser(userId: String) async throws -> DBUserModel {
        try await userDocument(userId: userId).getDocument(as: DBUserModel.self)
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
