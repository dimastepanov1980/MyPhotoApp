//
//  AddOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation
import SwiftUI

@MainActor
final class AddOrderViewModel: AddOrderViewModelType {
    @Published var status: String = ""
    @Published var name: String = ""
    @Published var instagramLink: String = ""
    @Published var price: String = ""
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    private let order: UserOrdersModel

    init(order: UserOrdersModel) {
        self.order = order
        updatePreview()
    }
    
    func updatePreview() {
        name = order.name ?? ""
        instagramLink = order.instagramLink ?? ""
        price = order.price ?? ""
        location = order.location ?? ""
        description = order.description ?? ""
        duration = order.duration ?? ""
        imageUrl = order.imageUrl ?? []
        date = order.date
        status = order.status ?? ""
    }
    
    func addOrder(order: UserOrdersModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.addNewOrder(userId: authDateResult.uid, order: order)
    }
   
    func updateOrder(orderModel: UserOrdersModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.updateOrder(userId: authDateResult.uid, order: orderModel, orderId: order.id)
    }
}
