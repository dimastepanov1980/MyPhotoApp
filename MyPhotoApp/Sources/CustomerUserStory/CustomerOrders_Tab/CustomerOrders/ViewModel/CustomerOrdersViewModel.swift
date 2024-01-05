//
//  CustomerOrdersViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
final class CustomerOrdersViewModel: CustomerOrdersViewModelType, ObservableObject {
    
    @Published var orders: [DbOrderModel]
    private var listenerRegistration: ListenerRegistration?

    init(orders: [DbOrderModel] = []) {
        self.orders = orders
        Task {
            print("init CustomerOrdersViewModel")
            try await subscribe()
        }
    }
    
    func orderStausColor (order: String?) -> Color {
        if let order = order {
            switch order {
            case "Upcoming":
                return Color(R.color.upcoming.name)
            case "In progress":
                return Color(R.color.inProgress.name)
            case "Completed":
                return Color(R.color.completed.name)
            case "Canceled":
                return Color(R.color.canceled.name)
            default:
                break
            }
        }
        return Color.gray
    }
    func orderStausName (status: String?) -> String {
        if let order = status {
            switch order {
            case "Upcoming":
                return R.string.localizable.status_upcoming()
            case "In progress":
                return R.string.localizable.status_inProgress()
            case "Completed":
                return R.string.localizable.status_completed()
            case "Canceled":
                return R.string.localizable.status_canceled()
            default:
                break
            }
        }
        return R.string.localizable.status_upcoming()
    }
    func subscribe() async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        print("subscribe to Customer: \(authDateResult)")
        listenerRegistration = UserManager.shared.subscribeCustomerOrder(userId: authDateResult.uid, completion: { orders in
            self.orders = orders
        })
    }
    
}
