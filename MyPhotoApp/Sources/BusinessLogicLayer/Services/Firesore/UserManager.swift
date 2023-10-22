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
    private let orderCollection = Firestore.firestore().collection("orders")

    private func customerDocument(customerId: String) -> DocumentReference {
        customerCollection.document(customerId)
    }
    
    func createNewCustomer(user: DBUserModel) async throws {
        try customerDocument(customerId: user.userId).setData(from: user, merge: false)
    }
    func updateProfileData(userId: String, profile: DBUserModel) async throws {
       
        let data: [String : Any] = [
            DBUserModel.CodingKeys.firstName.rawValue : profile.firstName ?? "",
            DBUserModel.CodingKeys.secondName.rawValue : profile.secondName ?? "",
            DBUserModel.CodingKeys.instagramLink.rawValue : profile.instagramLink ?? "",
            DBUserModel.CodingKeys.phone.rawValue : profile.phone ?? ""
        ]
        
        try? await customerDocument(customerId: userId).updateData(data)
        try? await authorDocument(authorId: userId).updateData(data)
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
    
    //MARK: - Orders
    func addNewOrder(userId: String, order: DbOrderModel) async throws {
        let customerOrder = orderCollection.document()
        let orderId = customerOrder.documentID
        
        guard let customerContact = try? encoder.encode(order.customerContactInfo) else {
            throw URLError(.badURL)
        }
        
        let orderData: [String : Any] = [
            DbOrderModel.CodingKeys.orderId.rawValue : orderId,
            DbOrderModel.CodingKeys.orderCreateDate.rawValue : Date(),
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            DbOrderModel.CodingKeys.orderStatus.rawValue : "upcoming", //R.string.localizable.status_upcoming()
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? [],
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : order.orderSamplePhotos ?? [],
            DbOrderModel.CodingKeys.orderMessages.rawValue : order.orderMessages ?? [],
             
            DbOrderModel.CodingKeys.authorId.rawValue :  order.authorId ?? "",
            DbOrderModel.CodingKeys.authorName.rawValue : order.authorName ?? "",
            DbOrderModel.CodingKeys.authorSecondName.rawValue : order.authorSecondName ?? "",
            DbOrderModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? "",
            DbOrderModel.CodingKeys.authorRegion.rawValue : order.authorRegion ?? "",

            DbOrderModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            
            DbOrderModel.CodingKeys.customerId.rawValue : order.customerId ?? "",
            DbOrderModel.CodingKeys.customerName.rawValue : order.customerName ?? "",
            DbOrderModel.CodingKeys.customerSecondName.rawValue : order.customerSecondName ?? "",
            DbOrderModel.CodingKeys.customerDescription.rawValue : order.customerDescription ?? "",
            DbOrderModel.CodingKeys.customerContactInfo.rawValue : customerContact
        ]
        try await customerOrder.setData(orderData, merge: false)
    }
    func getAuthorOrders(authorID: String) async throws -> [DbOrderModel] {
            try await orderCollection
                .whereField("author_id", isEqualTo: authorID)
                .getDocuments(as: DbOrderModel.self)
    }
    func getCustomerOrders(customerID: String) async throws -> [DbOrderModel] {
            try await orderCollection
                .whereField("customer_id", isEqualTo: customerID)
                .getDocuments(as: DbOrderModel.self)
    }


    //MARK: - Orders
    func addNewAuthorOrder(userId: String, order: DbOrderModel) async throws {
        let document = authorOrderCollection(authorId: userId).document()
        let documentId = document.documentID
        guard let customerContact = try? encoder.encode(order.customerContactInfo) else {
            throw URLError(.badURL)
        }
        
        let data: [String : Any] = [
            DbOrderModel.CodingKeys.orderId.rawValue : documentId,
            DbOrderModel.CodingKeys.orderCreateDate.rawValue : Date(),
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            DbOrderModel.CodingKeys.orderStatus.rawValue : "upcoming",
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? [],
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : order.orderSamplePhotos ?? [],
            DbOrderModel.CodingKeys.orderMessages.rawValue : order.orderMessages ?? [],
             
            DbOrderModel.CodingKeys.authorId.rawValue :  order.authorId ?? "",
            DbOrderModel.CodingKeys.authorName.rawValue : order.authorName ?? "",
            DbOrderModel.CodingKeys.authorSecondName.rawValue : order.authorSecondName ?? "",
            DbOrderModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? "",
            DbOrderModel.CodingKeys.authorRegion.rawValue : order.authorRegion ?? "",

            DbOrderModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            
            DbOrderModel.CodingKeys.customerId.rawValue : order.customerId ?? "",
            DbOrderModel.CodingKeys.customerName.rawValue : order.customerName ?? "",
            DbOrderModel.CodingKeys.customerSecondName.rawValue : order.customerSecondName ?? "",
            DbOrderModel.CodingKeys.customerDescription.rawValue : order.customerDescription ?? "",
            DbOrderModel.CodingKeys.customerContactInfo.rawValue : customerContact
      
        ]
        try await document.setData(data, merge: false)
    }
    func updateOrder(userId: String, order: DbOrderModel, orderId: String) async throws {
        guard let customerContact = try? encoder.encode(order.customerContactInfo) else {
            throw URLError(.badURL)
        }
        
        let data: [String : Any] = [
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            DbOrderModel.CodingKeys.orderStatus.rawValue : order.orderStatus ?? "upcoming", //R.string.localizable.status_upcoming()
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? [],
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : order.orderSamplePhotos ?? [],
            DbOrderModel.CodingKeys.orderMessages.rawValue : order.orderMessages ?? [],
             
            DbOrderModel.CodingKeys.authorId.rawValue :  order.authorId ?? "",
            DbOrderModel.CodingKeys.authorName.rawValue : order.authorName ?? "",
            DbOrderModel.CodingKeys.authorSecondName.rawValue : order.authorSecondName ?? "",
            DbOrderModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? "",
            DbOrderModel.CodingKeys.authorRegion.rawValue : order.authorRegion ?? "",

            DbOrderModel.CodingKeys.instagramLink.rawValue : order.instagramLink ?? "",
            
            DbOrderModel.CodingKeys.customerId.rawValue : order.customerId ?? "",
            DbOrderModel.CodingKeys.customerName.rawValue : order.customerName ?? "",
            DbOrderModel.CodingKeys.customerSecondName.rawValue : order.customerSecondName ?? "",
            DbOrderModel.CodingKeys.customerDescription.rawValue : order.customerDescription ?? "",
            DbOrderModel.CodingKeys.customerContactInfo.rawValue : customerContact
      
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
    //MARK: - Not used
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
        let authorDoc = authorDocument(authorId: userId)
        let portfolioId = portfolioDoc.documentID

        let portfolioData: [String : Any] = [
            DBPortfolioModel.CodingKeys.id.rawValue : portfolioId,
            DBPortfolioModel.CodingKeys.author.rawValue : authorData,
            DBPortfolioModel.CodingKeys.descriptionAuthor.rawValue : portfolio.descriptionAuthor ?? ""
        ]
        
        let authorInfo: [String : Any] = [
            DBUserModel.CodingKeys.firstName.rawValue : portfolio.author?.nameAuthor ?? "",
            DBUserModel.CodingKeys.secondName.rawValue : portfolio.author?.familynameAuthor ?? ""
        ]
        
        try await portfolioDoc.setData(portfolioData, merge: true)
        try await authorDoc.updateData(authorInfo)

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
