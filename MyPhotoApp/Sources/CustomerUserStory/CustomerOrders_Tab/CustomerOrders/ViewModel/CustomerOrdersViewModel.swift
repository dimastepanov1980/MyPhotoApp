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
    
    @Published var orders: [OrderModel] = []
    @Published var newMessagesCount: Int = 0
    private var listenerRegistration: [ListenerRegistration]?

    init() {
        Task {
            print("init CustomerOrdersViewModel")
            await subscribe()
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
    func subscribe() async {
        print("******************** init subscribe")
        do {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            listenerRegistration = UserManager.shared.subscribeToAllCustomerOrders(userId: authDateResult.uid) { receivedOrders in
                print(">>>>>>>>>>>> Orders received: \(receivedOrders.count)")
                self.orders = receivedOrders.sorted(by: { $0.orderShootingDate > $1.orderShootingDate }).map { OrderModel(order: $0) }
                self.newMessagesCount = self.orders.reduce(0) { result, order in
                    return result + order.newMessagesCustomer
                }
                print(">>>>>>>>>>>> Orders updated: \(self.orders.count)")
            }
        } catch {
            print(">>>>>>>>>>>> Error subscribing to orders: \(error.localizedDescription)")
        }
    }

}
