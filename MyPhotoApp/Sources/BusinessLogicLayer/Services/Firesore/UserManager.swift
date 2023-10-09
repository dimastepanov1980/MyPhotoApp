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
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    private var listenerRegistration: ListenerRegistration?

    //MARK: - Customer Section
    private let customerCollection = Firestore.firestore().collection("customer")
    private func customerDocument(customerId: String) -> DocumentReference {
        customerCollection.document(customerId)
    }
    
    func createNewCustomer(user: DBUserModel) async throws {
        try customerDocument(customerId: user.userId).setData(from: user, merge: false)
    }
    private func customerOrderCollection(authorId: String) -> CollectionReference {
        customerDocument(customerId: authorId).collection("orders")
    }
    
    //MARK: - Author Section
    private let authorCollection = Firestore.firestore().collection("users")
    
    private func authorDocument(authorId: String) -> DocumentReference {
        authorCollection.document(authorId)
    }
    private func authorOrderCollection(authorId: String) -> CollectionReference {
        authorDocument(authorId: authorId).collection("orders")
    }
    private func userOrderDocument(userId: String, orderId: String) -> DocumentReference {
        authorOrderCollection(authorId: userId).document(orderId)
    }
    
    func createNewAuthor(author: DBUserModel) async throws {
        try authorDocument(authorId: author.userId).setData(from: author, merge: false)
    }
    func getUser(userId: String) async throws -> DBUserModel {
        guard let user = try? await authorDocument(authorId: userId).getDocument(as: DBUserModel.self) else {
           return try await customerDocument(customerId: userId).getDocument(as: DBUserModel.self)
        }
        return user
    }
    
 /*   //MARK: - Customer Orders
    func addNewCustomerOrder(userId: String, order: CustomerOrdersModel) async throws {
        let document = authorOrderCollection(authorId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            CustomerOrdersModel.CodingKeys.orderId.rawValue : documentId,
            CustomerOrdersModel.CodingKeys.orderCreateDate.rawValue : Data(),
            CustomerOrdersModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            CustomerOrdersModel.CodingKeys.orderStatus.rawValue : "upcoming",
            CustomerOrdersModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            CustomerOrdersModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? "",
            CustomerOrdersModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            CustomerOrdersModel.CodingKeys.orderShootingPlace.rawValue : order.orderShootingPlace ?? "",
            CustomerOrdersModel.CodingKeys.orderSamplePhotos.rawValue : order.orderSamplePhotos ?? "",
            CustomerOrdersModel.CodingKeys.orderMessages.rawValue : order.orderMessages ?? [],
            CustomerOrdersModel.CodingKeys.customerId.rawValue : order.customerId,
            CustomerOrdersModel.CodingKeys.customerName.rawValue : order.customerName ?? "",
            CustomerOrdersModel.CodingKeys.customerSecondName.rawValue : order.customerSecondName ?? "",
            CustomerOrdersModel.CodingKeys.customerDescription.rawValue : order.customerDescription ?? "",
            CustomerOrdersModel.CodingKeys.customerContactInfo.rawValue : order.customerContactInfo ?? "",
            CustomerOrdersModel.CodingKeys.authorId.rawValue : order.authorId,
            CustomerOrdersModel.CodingKeys.authorName.rawValue : order.authorName,
            CustomerOrdersModel.CodingKeys.authorSecondName.rawValue : order.authorSecondName,
            CustomerOrdersModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? ""
                ]
        try await document.setData(data, merge: false)
    }
*/
    
    //MARK: - Author Orders
    func addNewOrder(userId: String, order: DbOrderModel) async throws {
        let document = authorOrderCollection(authorId: userId).document()
        let documentId = document.documentID
        
        let data: [String : Any] = [
            DbOrderModel.CodingKeys.orderId.rawValue : documentId,
            DbOrderModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? "",
            DbOrderModel.CodingKeys.authorName.rawValue : order.authorName ?? "",
            DbOrderModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "0",
            DbOrderModel.CodingKeys.description.rawValue : order.description  ?? "",
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? [],
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : order.orderSamplePhotos ?? [""],
            DbOrderModel.CodingKeys.orderStatus.rawValue : "upcoming" //R.string.localizable.status_upcoming()
        ]
        try await document.setData(data, merge: false)
    }
    func updateOrder(userId: String, order: DbOrderModel, orderId: String) async throws {
        let data: [String : Any] = [
            DbOrderModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? "",
            DbOrderModel.CodingKeys.authorName.rawValue : order.authorName ?? "",
            DbOrderModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            DbOrderModel.CodingKeys.description.rawValue : order.description  ?? "",
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.orderStatus.rawValue : order.orderStatus ??  "upcoming"//R.string.localizable.status_upcoming()
        ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data)
    }
    func updateStatus(userId: String, order: DbOrderModel, orderId: String) async throws {
        let data: [String : Any] = [
            DbOrderModel.CodingKeys.orderStatus.rawValue : order.orderStatus ?? R.string.localizable.status_upcoming()
        ]
        try await userOrderDocument (userId: userId, orderId: orderId).updateData(data)
    }
    func removeOrder(userId: String, order: DbOrderModel) async throws {
        try await userOrderDocument(userId: userId, orderId: order.orderId).delete()
    }
    func addToImagesUrlLinks(userId: String, path: [String], orderId: String) async throws {
        try await userOrderDocument (userId: userId, orderId: orderId).updateData([DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : FieldValue.arrayUnion(path)])
    }
    func deleteImagesUrlLinks(userId: String, path: [String], orderId: String) async throws {
        try await userOrderDocument(userId: userId, orderId: orderId).updateData([DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : path])
    }
    func getAllOrders(userId: String) async throws -> [DbOrderModel] {
        try await authorOrderCollection(authorId: userId).getDocuments(as: DbOrderModel.self)
    }
    func addListenerRegistration(userId: String, completion: @escaping ([DbOrderModel]) -> Void) -> ListenerRegistration {
        // Assuming you have a reference to your Firestore collection
        let query = authorOrderCollection(authorId: userId)
        
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
                try? queryDocumentSnapshot.data(as: DbOrderModel.self)
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
    func getCurrentOrders(userId: String, order: DbOrderModel) async throws -> DbOrderModel {
        try await userOrderDocument(userId: userId, orderId: order.orderId).getDocument(as: DbOrderModel.self)
    }
    
    //MARK: - Portfolio
    
    private let portfolioCollection = Firestore.firestore().collection("portfolio")
    
    private func portfolioUserDocument(userId: String) -> DocumentReference {
        portfolioCollection.document(userId)
    }
    func setUserPortfolio(userId: String, portfolio: DBPortfolioModel) async throws {
        guard let authorData = try? encoder.encode(portfolio.author) else {
            throw URLError(.badURL)
        }
        let portfolioDoc = portfolioUserDocument(userId: userId)
        let portfolioId = portfolioDoc.documentID

        let dict: [String : Any] = [
            DBPortfolioModel.CodingKeys.id.rawValue : portfolioId,
            DBPortfolioModel.CodingKeys.author.rawValue : authorData,
            DBPortfolioModel.CodingKeys.descriptionAuthor.rawValue : portfolio.descriptionAuthor ?? ""
        ]
        try await portfolioDoc.setData(dict, merge: true)
    }
    func getUserPortfolio(userId: String) async throws -> DBPortfolioModel {
        try await portfolioUserDocument(userId: userId).getDocument(as: DBPortfolioModel.self)
    }
    func setUserSchedule(userId: String, schedules: Schedule) async throws {
        guard let schedul = try? encoder.encode(schedules) else {
            throw URLError(.badURL)
        }
        let portfolioDoc = portfolioUserDocument(userId: userId)
        try await portfolioDoc.setData([DBPortfolioModel.CodingKeys.schedule.rawValue : FieldValue.arrayUnion([schedul])], merge: true)
    }
    func removeUserSchedule(userId: String) async throws {
        let portfolioDoc = portfolioUserDocument(userId: userId)
        try await portfolioDoc.updateData([DBPortfolioModel.CodingKeys.schedule.rawValue : [] as NSArray])
    }
    func getUserSchedule(userId: String) async throws -> DBPortfolioModel {
        try await portfolioUserDocument(userId: userId).getDocument(as: DBPortfolioModel.self)
    }
    func addAvatarUrl(userId: String, path: String) async throws {
        try await portfolioUserDocument(userId: userId).setData([DBPortfolioModel.CodingKeys.avatarAuthor.rawValue : path], mergeFields: [DBPortfolioModel.CodingKeys.avatarAuthor.rawValue])
    }
    func addPortfolioImagesUrl(userId: String, path: [String]) async throws {
        try await portfolioUserDocument(userId: userId).updateData([DBPortfolioModel.CodingKeys.smallImagesPortfolio.rawValue : FieldValue.arrayUnion(path)])
    }
    func deletePortfolioImage(userId: String, path: String) async throws {
        let arrayRemoveValue = FieldValue.arrayRemove([path])
          try await portfolioUserDocument(userId: userId).updateData([DBPortfolioModel.CodingKeys.smallImagesPortfolio.rawValue: arrayRemoveValue])
    }
    func getAllPortfolio() async throws -> [DBPortfolioModel] {
        try await portfolioCollection.getDocuments(as: DBPortfolioModel.self)
    }
    func getPortfolioForCoordinateAndDate(longitude: Double, latitude: Double, startEventDate: Date) async throws -> [DBPortfolioModel] {
        // Query based on longitude range
        let longitudeQuerySnapshot = try await portfolioCollection
            .whereField("author.longitude", isGreaterThan: longitude - 0.01 * longitude)
            .whereField("author.longitude", isLessThan: longitude + 0.01 * longitude)
            .getDocuments(as: DBPortfolioModel.self)

        // Query based on latitude range
        let latitudeQuerySnapshot = try await portfolioCollection
            .whereField("author.latitude", isGreaterThan: latitude - 0.01 * latitude)
            .whereField("author.latitude", isLessThan: latitude + 0.01 * latitude)
            .getDocuments(as: DBPortfolioModel.self)

        // Combine the queries
        let commonPortfolios = Set(longitudeQuerySnapshot).intersection(Set(latitudeQuerySnapshot))

        // Filter portfolios where the startDate is greater than or equal to the provided startDate
        let filteredPortfolios = commonPortfolios.filter { portfolio in
            guard let schedule = portfolio.schedule else { return false }
            return schedule.contains { $0.startDate <= startEventDate }
        }
        print(Array(filteredPortfolios))
        return Array(filteredPortfolios)
    }
    func matchesLocation(_ location: String, searchString: String) -> Bool {
        let options: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        return location.range(of: searchString, options: options) != nil
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
