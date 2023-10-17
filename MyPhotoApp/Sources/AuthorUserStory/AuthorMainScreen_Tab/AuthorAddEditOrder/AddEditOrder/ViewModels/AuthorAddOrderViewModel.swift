//
//  AuthorAddOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation
import SwiftUI

@MainActor
final class AuthorAddOrderViewModel: AuthorAddOrderViewModelType {
    @Published var status: String = ""
    @Published var name: String = ""
    @Published var secondName: String = ""
    @Published var instagramLink: String = ""
    @Published var price: String = ""
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    @Published var order: DbOrderModel

    init(order: DbOrderModel) {
        self.order = order
        updatePreview()
    }
    
    func updatePreview() {
        name = order.authorName ?? ""
        instagramLink = order.instagramLink ?? ""
        price = order.orderPrice ?? ""
        location = order.authorLocation ?? ""
        description = order.customerDescription ?? ""
        duration = order.orderShootingDuration ?? ""
        imageUrl = order.orderSamplePhotos ?? []
        date = order.orderShootingDate
        status = order.orderStatus ?? ""
    }
    func addOrder(order: DbOrderModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.addNewAuthorOrder(userId: authDateResult.uid, order: order)
    }
    func updateOrder(orderModel: DbOrderModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.updateOrder(userId: authDateResult.uid, order: orderModel, orderId: order.orderId)
    }
}
