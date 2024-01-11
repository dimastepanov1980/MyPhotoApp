//
//  MessagerViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

@MainActor
final class MessagerViewModel: MessagerViewModelType {
    @Published var getMessage: [MessageModel]?
    @Published var orderId: String
    private var listenerRegistration: ListenerRegistration?
    
    init(orderId: String) {
        self.orderId = orderId
        subscribe()
    }
    
    func subscribe() {
        listenerRegistration = UserManager.shared.subscribeMessage(orderId: orderId) { message in
            self.getMessage = message.map { MessageModel(message: $0) }.sorted(by: { $0.timestamp < $1.timestamp })
        }
    }
    
    func messageViewed(messages: [MessageModel]) async throws {
        for message in messages {
            do {
                try await UserManager.shared.messageViewed(orderId: orderId, messageID: message.id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addNewMessage(message: MessageModel) async throws {
        do {
            try await UserManager.shared.addNewMessage(orderId: orderId, message: DBMessageModel(message: message))
            print(message)
        } catch {
            print(error.localizedDescription)
        }
    }
}
