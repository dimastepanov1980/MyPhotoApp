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
    
    //MARK: - Author Section
    private let userCollection = Firestore.firestore().collection("users")
   
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    private var listenerRegistration: ListenerRegistration?
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    private func userOrderCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("orders")
    }
    private func userOrderDocument(userId: String, orderId: String) -> DocumentReference {
        userOrderCollection(userId: userId).document(orderId)
    }
    private func userPortfolioCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("portfolio")
    }
    
    func createNewUser(user: DBUserModel) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
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
            UserOrdersModel.CodingKeys.status.rawValue : R.string.localizable.status_upcoming()
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
                   UserOrdersModel.CodingKeys.status.rawValue : order.status ?? R.string.localizable.status_upcoming()
               ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data)
    }
    func updateStatus(userId: String, order: UserOrdersModel, orderId: String) async throws {
        let data: [String : Any] = [
                   UserOrdersModel.CodingKeys.status.rawValue : order.status ?? R.string.localizable.status_upcoming()
               ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data)
    }
    func removeOrder(userId: String, order: UserOrdersModel) async throws {
        try await userOrderDocument(userId: userId, orderId: order.id).delete()
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
    func deleteImagesUrlLinks(userId: String, path: [String], orderId: String) async throws {
        try await userOrderDocument (userId: userId, orderId: orderId).updateData([UserOrdersModel.CodingKeys.imageUrl.rawValue : path])
    }
    func getAllOrders(userId: String) async throws -> [UserOrdersModel] {
        try await userOrderCollection(userId: userId).getDocuments(as: UserOrdersModel.self)
    }
    func addListenerRegistration(userId: String, completion: @escaping ([UserOrdersModel]) -> Void) -> ListenerRegistration {
        // Assuming you have a reference to your Firestore collection
        let query = userOrderCollection(userId: userId)

        // Set up the snapshot listener
        let listenerRegistration = query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                print("No documents")
                return
            }

            let orders = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserOrdersModel.self)
            }
            // Do something with the orders array (e.g., update UI, process data, etc.)
            completion(orders)
        }

        return listenerRegistration
    }
    func unsubscribe() {
      if listenerRegistration != nil {
        listenerRegistration?.remove()
        listenerRegistration = nil
      }
    }
    func getCurrentOrders(userId: String, order: UserOrdersModel) async throws -> UserOrdersModel {
        try await userOrderDocument(userId: userId, orderId: order.id).getDocument(as: UserOrdersModel.self)
    }
    func getUser(userId: String) async throws -> DBUserModel {
        try await userDocument(userId: userId).getDocument(as: DBUserModel.self)
    }
    
    func setUserPortfolio(userId: String, portfolio: DBPortfolioModel) async throws {
        guard let authorData = try? encoder.encode(portfolio.author) else {
            throw URLError(.badURL)
        }
        let portfolioDoc = userPortfolioCollection(userId: userId).document(userId)
        let portfolioId = portfolioDoc.documentID

        let dict: [String : Any] = [
            DBPortfolioModel.CodingKeys.id.rawValue : portfolioId,
            DBPortfolioModel.CodingKeys.author.rawValue : authorData,
//            DBPortfolioModel.CodingKeys.avatarAuthor.rawValue : portfolio.avatarAuthor ?? "",
            DBPortfolioModel.CodingKeys.descriptionAuthor.rawValue : portfolio.descriptionAuthor ?? ""
        ]
        try await portfolioDoc.updateData(dict)
    }
    func getUserPortfolio(userId: String) async throws -> DBPortfolioModel {
        try await userPortfolioCollection(userId: userId).document(userId).getDocument(as: DBPortfolioModel.self)
    }
    
    // MARK: - Old Customer Section
    private let portfolioCollection = Firestore.firestore().collection("portfolio")
    
    private func authorLocation(location: String) -> DocumentReference {
        portfolioCollection.document(location)
    }
    private func authorsPortfolionOnLocation(location: String) -> CollectionReference {
        authorLocation(location: location).collection("author")
    }

    func getAllPortfolio(location: String) async throws -> [DBPortfolioModel] {
        try await authorsPortfolionOnLocation(location: location).getDocuments(as: DBPortfolioModel.self)
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
