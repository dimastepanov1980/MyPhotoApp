//
//  CustomerOrdersViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import Foundation
import FirebaseFirestore

@MainActor

final class CustomerOrdersViewModel: CustomerOrdersViewModelType, ObservableObject {
    @Published var orders: [DbOrderModel]
    private var listenerRegistration: ListenerRegistration?

    init(orders: [DbOrderModel] = []) {
        self.orders = orders
        Task {
            try await subscribe()
        }
    }
    
    func subscribe() async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        print("subscribe to Customer: \(authDateResult)")
        listenerRegistration = UserManager.shared.subscribeCustomerOrder(userId: authDateResult.uid, completion: { orders in
            self.orders = orders
        })
    }
    
}
