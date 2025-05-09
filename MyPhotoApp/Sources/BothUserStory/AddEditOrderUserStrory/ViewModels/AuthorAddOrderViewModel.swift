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
    @Published var order: OrderModel?

    @Published var status: String = ""
    @Published var name: String = ""
    @Published var secondName: String = ""
    
    @Published var instagramLink: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    
    @Published var authorId: String = ""
    @Published var price: String = ""
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var time: String = ""
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []

    init(order: OrderModel?) {
        self.order = order
        updatePreview()
    }
    
     func updatePreview() {
         name = order?.customerName ?? ""
         secondName = order?.customerSecondName ?? ""
         instagramLink = order?.customerContactInfo.instagramLink ?? ""
         phone = order?.customerContactInfo.phone ?? ""
         email = order?.customerContactInfo.email ?? ""
         authorId = order?.authorId ?? ""
         price = order?.orderPrice ?? ""
         location = order?.authorLocation ?? ""
         description = order?.customerDescription ?? ""
         duration = order?.orderShootingDuration ?? ""
         imageUrl = order?.orderSamplePhotos ?? []
         date = order?.orderShootingDate ?? Date()
         status = order?.orderStatus ?? ""
     }
    
    func dateToString(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        self.time = dateFormatter.string(from: date)
        print("time: \(time)")
    }
    func addOrder(order: DbOrderModel, userId: String) async throws {
        print("addOrder details: \(order), \(userId)")
        let orderId = try await UserManager.shared.addNewOrder(userId: userId, order: order)
    }
    func updateOrder(orderModel: DbOrderModel) async throws {
        try? await UserManager.shared.updateOrder(order: orderModel, orderId: order?.orderId ?? "")
    }
}
