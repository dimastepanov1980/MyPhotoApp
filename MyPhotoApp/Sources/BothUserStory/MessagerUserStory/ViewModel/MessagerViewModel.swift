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
    @Published var getMessage: MessagerModel?
    @Published var orderId: String
    private var listenerRegistration: ListenerRegistration?
    
    init(orderId: String) {
        self.orderId = orderId
        subscribe()
    }
    
    func subscribe() {
        listenerRegistration = UserManager.shared.subscribeMessage(orderId: orderId) { message in
            self.getMessage = MessagerModel(item: message)
        }
    }
   
    func subscribeAuthor() {
        listenerRegistration = UserManager.shared.subscribeMessageAuthor(id: orderId) { message in
//            self.getMessage = MessagerModel(item: message)
        }
    }
    
    func addNewMessage(message: MessageModel) async throws {
        do {
            try await UserManager.shared.addNewMessage(orderId: orderId, message: DBMessageModel(message: message))
        } catch {
            print(error.localizedDescription)
        }
    }
}
