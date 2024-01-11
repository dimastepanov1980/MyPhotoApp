//
//  UserManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/29/23.
//

import Foundation
import FirebaseCore
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
    
    private let orderCollection = Firestore.firestore().collection("orders")
    private let chatCollection = Firestore.firestore().collection("chats")
    private let userCollection = Firestore.firestore().collection("users")

    func updateProfileData(userId: String, profile: DBUserModel) async throws {
       
        let data: [String : Any] = [
            DBUserModel.CodingKeys.firstName.rawValue : profile.firstName ?? "",
            DBUserModel.CodingKeys.secondName.rawValue : profile.secondName ?? "",
            DBUserModel.CodingKeys.instagramLink.rawValue : profile.instagramLink ?? "",
            DBUserModel.CodingKeys.phone.rawValue : profile.phone ?? ""
        ]
        try? await userDocument(authorId: userId).updateData(data)
    }
    
    func swichUserType(userId: String, userType: String) async throws {
        try? await userDocument(authorId: userId).updateData([ DBUserModel.CodingKeys.userType.rawValue : userType ])
    }

    
    //MARK: - Author Section
    
    private func userDocument(authorId: String) -> DocumentReference {
        userCollection.document(authorId)
    }
    
    private func chatDocumentForOrder(orderId: String) -> DocumentReference {
        chatCollection.document(orderId)
    }
    
    func createNewUser(author: DBUserModel) async throws {
        try userDocument(authorId: author.userId).setData(from: author, merge: false)
    }
    func getUser(userId: String) async throws -> DBUserModel {
        return try await userDocument(authorId: userId).getDocument(as: DBUserModel.self)
    }
    func updateToken(userId: String, token: String) async throws {
        try? await userDocument(authorId: userId).updateData([ DBUserModel.CodingKeys.token.rawValue : token ])
    }
    //MARK: - NEW Query Orders
    func addNewOrder(userId: String, order: DbOrderModel) async throws -> String {
        let customerOrder = orderCollection.document()
        let orderId = customerOrder.documentID
        guard let customerContact = try? encoder.encode(order.customerContactInfo) else {
            throw URLError(.badURL)
        }
        let orderData: [String : Any] = [
            DbOrderModel.CodingKeys.orderId.rawValue : orderId,
            DbOrderModel.CodingKeys.orderCreateDate.rawValue : Date(),
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            DbOrderModel.CodingKeys.orderStatus.rawValue : "Upcoming", //R.string.localizable.status_upcoming()
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? [],
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : order.orderSamplePhotos ?? [],
            DbOrderModel.CodingKeys.orderMessages.rawValue : order.orderMessages,
            
            DbOrderModel.CodingKeys.authorId.rawValue :  order.authorId ?? "",
            DbOrderModel.CodingKeys.authorName.rawValue : order.authorName ?? "",
            DbOrderModel.CodingKeys.authorSecondName.rawValue : order.authorSecondName ?? "",
            DbOrderModel.CodingKeys.authorLocation.rawValue : order.authorLocation ?? "",
            DbOrderModel.CodingKeys.authorRegion.rawValue : order.authorRegion ?? "",
            
            DbOrderModel.CodingKeys.customerId.rawValue : order.customerId ?? "",
            DbOrderModel.CodingKeys.customerName.rawValue : order.customerName ?? "",
            DbOrderModel.CodingKeys.customerSecondName.rawValue : order.customerSecondName ?? "",
            DbOrderModel.CodingKeys.customerDescription.rawValue : order.customerDescription ?? "",
            DbOrderModel.CodingKeys.customerContactInfo.rawValue : customerContact
        ]
        try await customerOrder.setData(orderData, merge: false)
        return orderId
    }
    func subscribeAuthorOrders(userId: String, completion: @escaping ([DbOrderModel]) -> Void) -> ListenerRegistration {
        let query = orderCollection.whereField("author_id", isEqualTo: userId)
        let listenerRegistration = query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("-------------------------------Error fetching documents: \(error)-------------------------------")
                return
            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                print("-------------------------------No documents-------------------------------")
                return
            }
            
            let orders = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: DbOrderModel.self)
            }
            completion(orders)
        }
        
        return listenerRegistration
    }
    func subscribeCustomerOrder(userId: String, completion: @escaping ([DbOrderModel]) -> Void) -> ListenerRegistration {
        let query = orderCollection.whereField("customer_id", isEqualTo: userId)
        
        let listenerRegistration = query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("-------------------------------Error fetching documents: \(error)-------------------------------")
                return
            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                print("-------------------------------No documents-------------------------------")
                return
            }
            
            let orders = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: DbOrderModel.self)
            }
            completion(orders)
        }
        return listenerRegistration
    }
    func createNewChat(orderId: String, authorId: String, customerId: String) async throws {
        let chatData: [String : Any] = [
            DBMessagerModel.CodingKeys.id.rawValue : orderId,
            DBMessagerModel.CodingKeys.authorId.rawValue : authorId,
            DBMessagerModel.CodingKeys.customerId.rawValue : customerId,
            ]
        do {
            try await chatDocumentForOrder(orderId: orderId).setData(chatData, merge: false)
        } catch {
            print(error.localizedDescription)
        }
       
    }
    func addNewMessage(orderId: String, message: DBMessageModel) async throws {
        let newMessageDocument = orderCollection.document(orderId).collection("messages").document()
        let messageId = newMessageDocument.documentID

        let messageData: [String : Any] = [
            DBMessageModel.CodingKeys.id.rawValue : messageId,
            DBMessageModel.CodingKeys.isViewed.rawValue : message.isViewed,
            DBMessageModel.CodingKeys.message.rawValue : message.message,
            DBMessageModel.CodingKeys.timestamp.rawValue : message.timestamp,
            DBMessageModel.CodingKeys.senderIsAuthor.rawValue : message.senderIsAuthor
        ]
        try await newMessageDocument.setData(messageData)
    }
    func messageViewed(orderId: String, messageID: String) async throws {
        let messageDocument = chatDocumentForOrder(orderId: orderId).collection("messages").document(messageID)
        try await messageDocument.updateData([DBMessageModel.CodingKeys.isViewed.rawValue : true])

    }
    func subscribeMessage(orderId: String, completion: @escaping ([DBMessageModel]) -> Void) -> ListenerRegistration {
        return chatCollection.document(orderId).collection("messages").addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("No documents---\(String(describing: error?.localizedDescription))----------------------------")
                return
            }
            let message = querySnapshot.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: DBMessageModel.self)
            }
            completion(message)
        }
    }
    
    func subscribeMessageCustomer(userId: String, completion: @escaping ([String : [DBMessageModel]]) -> Void) -> [ListenerRegistration] {
        let query = chatCollection.whereField("customer_id", isEqualTo: userId)
        var listenerRegistrations: [ListenerRegistration] = []

        query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }

            // Loop through each document
            for document in documents {
                let orderId = document.documentID
                let subcollectionRef = self.chatCollection.document(orderId).collection("messages")

                // Add a listener for each subcollection
                let listenerRegistration = subcollectionRef.addSnapshotListener { subcollectionSnapshot, subcollectionError in
                    if let subcollectionError = subcollectionError {
                        print("Error fetching subcollection: \(subcollectionError.localizedDescription)")
                        return
                    }

                    guard let subcollectionSnapshot = subcollectionSnapshot else {
                        print("No subcollection documents found.")
                        return
                    }

                    let messages = subcollectionSnapshot.documents.compactMap { subcollectionDocument in
                        try? subcollectionDocument.data(as: DBMessageModel.self)
                    }

                    print("Subcollection messages: \(messages), Document ID: \(orderId)")
                    completion([orderId : messages])
                }

                listenerRegistrations.append(listenerRegistration)
            }
        }

        return listenerRegistrations
    }
    
//    func subscribeMessageCustomer(id: String, completion: @escaping ([DBMessagerModel]) -> Void) -> ListenerRegistration {
//        let query = chatCollection.whereField("customer_id", isEqualTo: id)
//        let listenerRegistration = query.addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("-------------------------------Error fetching documents: \(error)-------------------------------")
//                return
//            }
//            
//            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
//                print("No documents---\(error?.localizedDescription)----------------------------")
//                return
//            }
//            let message = querySnapshot.documents.compactMap { queryDocumentSnapshot in
//                
//                try? queryDocumentSnapshot.data(as: DBMessagerModel.self)
//            }
//            print("message: \(message), orderId: \(id), querySnapshot: \(querySnapshot.count)")
//            completion(message)
//        }
//        return listenerRegistration
//    }
//    func subscribeMessageAuthor(id: String, completion: @escaping ([DBMessagerModel]) -> Void) -> ListenerRegistration {
//        let query = chatCollection.whereField("author_id", isEqualTo: id)
//        
//        return query.addSnapshotListener { querySnapshot, error in
//            let message = querySnapshot?.documents.compactMap { documents -> DBMessagerModel? in
//                    do {
//                        return try documents.data(as: DBMessagerModel.self)
//                    } catch {
//                        print(error.localizedDescription)
//                        return nil
//                    }
//                }
//            completion(message!)
//
//        }
//    }
    func addSampleImageUrl(path: [String], orderId: String) async throws {
        try await orderCollection.document(orderId).updateData([DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : FieldValue.arrayUnion(path)])
    }
    func deleteSampleImageUrl(path: String, orderId: String) async throws {
        try await orderCollection.document(orderId).updateData([DbOrderModel.CodingKeys.orderSamplePhotos.rawValue : FieldValue.arrayRemove([path])])
    }
    func updateStatus(order: DbOrderModel, orderId: String) async throws {
        let orderData: [String : Any] = [
            DbOrderModel.CodingKeys.orderStatus.rawValue : order.orderStatus as Any
        ]
        try await orderCollection.document(orderId).updateData(orderData)
    }
    func updateOrder(order: DbOrderModel, orderId: String) async throws {
        guard let customerContact = try? encoder.encode(order.customerContactInfo) else {
            throw URLError(.badURL)
        }
        let orderData: [String : Any] = [
            DbOrderModel.CodingKeys.orderPrice.rawValue : order.orderPrice ?? "",
            DbOrderModel.CodingKeys.orderShootingDate.rawValue : order.orderShootingDate,
            DbOrderModel.CodingKeys.orderShootingTime.rawValue : order.orderShootingTime ?? [],
            DbOrderModel.CodingKeys.orderShootingDuration.rawValue : order.orderShootingDuration ?? "",
            DbOrderModel.CodingKeys.customerName.rawValue : order.customerName ?? "",
            DbOrderModel.CodingKeys.customerSecondName.rawValue : order.customerSecondName ?? "",
            DbOrderModel.CodingKeys.customerDescription.rawValue : order.customerDescription ?? "",
            DbOrderModel.CodingKeys.customerContactInfo.rawValue : customerContact
        ]
        try await orderCollection.document(orderId).updateData(orderData)
    }
 
  // MARK: - Manage Booking Days
    func addNewBookingDays(userId: String, selectedDay: String, selectedTimes: [String]) async throws {
        try await portfolioUserDocument(userId: userId).updateData(["\(DBPortfolioModel.CodingKeys.bookingDays.rawValue).\(selectedDay)" : selectedTimes])
         }
    func addTimeSlotForBookingDay(userId: String, selectedDay: String, selectedTime: String) async throws {
        try await portfolioUserDocument(userId: userId).updateData(["\(DBPortfolioModel.CodingKeys.bookingDays.rawValue).\(selectedDay)" : FieldValue.arrayUnion([selectedTime])])
    }
    func removeTimeSlotFromBookingDay(userId: String, selectedDay: String, selectedTime: String) async throws {
        try await portfolioUserDocument(userId: userId).updateData(["\(DBPortfolioModel.CodingKeys.bookingDays.rawValue).\(selectedDay)" : FieldValue.arrayRemove([selectedTime])])
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
        let authorDoc = userDocument(authorId: userId)
        let portfolioId = portfolioDoc.documentID
        let portfolioData: [String : Any] = [
            DBPortfolioModel.CodingKeys.id.rawValue : portfolioId,
            DBPortfolioModel.CodingKeys.author.rawValue : authorData,
            DBPortfolioModel.CodingKeys.schedule.rawValue : FieldValue.arrayUnion([]),
            DBPortfolioModel.CodingKeys.descriptionAuthor.rawValue : portfolio.descriptionAuthor ?? ""
        ]
        
        let authorInfo: [String : Any] = [
            DBUserModel.CodingKeys.firstName.rawValue : portfolio.author?.nameAuthor ?? "",
            DBUserModel.CodingKeys.secondName.rawValue : portfolio.author?.familynameAuthor ?? "",
            DBUserModel.CodingKeys.setPortfolio.rawValue : true
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
    func addAvatarToPortfolio(userId: String, path: String) async throws {
        try await portfolioUserDocument(userId: userId).setData([DBPortfolioModel.CodingKeys.avatarAuthor.rawValue : path], mergeFields: [DBPortfolioModel.CodingKeys.avatarAuthor.rawValue])
    }
    func addAvatarToAuthorProfile(userId: String, path: String) async throws {
        try await userDocument(authorId: userId).setData([DBUserModel.CodingKeys.avatarUser.rawValue : path], mergeFields: [DBUserModel.CodingKeys.avatarUser.rawValue])
    }
    func addImageUrlToPortfolio(userId: String, path: String) async throws {
        try await portfolioUserDocument(userId: userId).updateData([DBPortfolioModel.CodingKeys.smallImagesPortfolio.rawValue : FieldValue.arrayUnion([path])])
    }
    func deletePortfolioImage(userId: String, path: String) async throws {
        let arrayRemoveValue = FieldValue.arrayRemove([path])
          try await portfolioUserDocument(userId: userId).updateData([DBPortfolioModel.CodingKeys.smallImagesPortfolio.rawValue: arrayRemoveValue])
    }
    func getAllPortfolio(startEventDate: Date) async throws -> [DBPortfolioModel] {
       let portfolios = try await portfolioCollection.getDocuments(as: DBPortfolioModel.self)
        
        let filteredPortfolios = portfolios.filter { portfolio in
            guard let schedule = portfolio.schedule else { return false }
            return schedule.contains { $0.startDate <= startEventDate }
        }
        return Array(filteredPortfolios)
    }
    func getPortfolioForCoordinateAndDate(longitude: Double, latitude: Double, startEventDate: Date) async throws -> [DBPortfolioModel] {
        // Query based on longitude range
        do {
            var longitudeQuerySnapshot = try await portfolioCollection
                .whereField("author.longitude", isGreaterThan: longitude - 0.01 * longitude)
                .whereField("author.longitude", isLessThan: longitude + 0.01 * longitude)
                .getDocuments(as: DBPortfolioModel.self)
            
            if longitudeQuerySnapshot.isEmpty {
                print("-----------------------------------get longitude 0.03 portoflio-----------------------------------")
                 longitudeQuerySnapshot = try await portfolioCollection
                    .whereField("author.longitude", isGreaterThan: longitude - 0.03 * longitude)
                    .whereField("author.longitude", isLessThan: longitude + 0.03 * longitude)
                    .getDocuments(as: DBPortfolioModel.self)
            }
            
            if longitudeQuerySnapshot.isEmpty {
                print("-----------------------------------get longitude 0.1 portoflio-----------------------------------")
                 longitudeQuerySnapshot = try await portfolioCollection
                    .whereField("author.longitude", isGreaterThan: longitude - 0.1 * longitude)
                    .whereField("author.longitude", isLessThan: longitude + 0.1 * longitude)
                    .getDocuments(as: DBPortfolioModel.self)
            }

            // Query based on latitude range
            var latitudeQuerySnapshot = try await portfolioCollection
                .whereField("author.latitude", isGreaterThan: latitude - 0.01 * latitude)
                .whereField("author.latitude", isLessThan: latitude + 0.01 * latitude)
                .getDocuments(as: DBPortfolioModel.self)
            
            if latitudeQuerySnapshot.isEmpty {
                print("-----------------------------------get latitude 0.03 portoflio-----------------------------------")
                latitudeQuerySnapshot = try await portfolioCollection
                    .whereField("author.latitude", isGreaterThan: latitude - 0.03 * latitude)
                    .whereField("author.latitude", isLessThan: latitude + 0.03 * latitude)
                    .getDocuments(as: DBPortfolioModel.self)
            }
            
            if latitudeQuerySnapshot.isEmpty {
                print("-----------------------------------get latitude 0.1 portoflio-----------------------------------")
                latitudeQuerySnapshot = try await portfolioCollection
                    .whereField("author.latitude", isGreaterThan: latitude - 0.1 * latitude)
                    .whereField("author.latitude", isLessThan: latitude + 0.1 * latitude)
                    .getDocuments(as: DBPortfolioModel.self)
            }

            // Combine the queries
            let commonPortfolios = Set(longitudeQuerySnapshot).intersection(Set(latitudeQuerySnapshot))

            // Filter portfolios where the startDate is greater than or equal to the provided startDate
            let filteredPortfolios = commonPortfolios.filter { portfolio in
                guard let schedule = portfolio.schedule else { return false }
                return schedule.contains { $0.startDate <= startEventDate }
            }
            
            print("filteredPortfolios: \(Array(filteredPortfolios))")
            print("commonPortfolios:  \(Array(commonPortfolios))")
            return Array(filteredPortfolios)
        } catch  {
            print(String(describing: error))
        }
        
        return []
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
                print("-----------------------------------No documents-----------------------------------")
                return
            }
            
            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
}
