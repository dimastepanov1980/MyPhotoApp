//
//  CustomerOrdersViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import Foundation

@MainActor

final class CustomerOrdersViewModel: CustomerOrdersViewModelType, ObservableObject {
    @Published var selectedOrder: DbOrderModel? = nil
    @Published var orders: [DbOrderModel]
    
    init(orders: [DbOrderModel] = []) {
        self.orders = orders
        
        Task {
            try await getOrders()
        }
    }
    
    func getOrders() async throws {
                let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
                self.orders = try await UserManager.shared.getCustomerOrders(customerID: userDataResult.uid)
                print(orders)
    }
    
}
