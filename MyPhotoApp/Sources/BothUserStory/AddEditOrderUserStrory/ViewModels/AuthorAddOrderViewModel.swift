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
    @Published var phone: String = ""
    @Published var email: String = ""
    
    @Published var authorId: String = ""
    @Published var price: String = ""
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    @Published var order: DbOrderModel?

    init(order: DbOrderModel? = nil) {
        updatePreview()
        Task{
            try await getUser()
        }
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
    func getUser() async throws {
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        print(userDataResult.uid)
        self.authorId = userDataResult.uid
    }
    
    func addOrder(order: DbOrderModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        print("addOrder: \(order)")
        try? await UserManager.shared.addNewOrder(userId: authDateResult.uid, order: order)
    }
    func updateOrder(orderModel: DbOrderModel) async throws {
        try? await UserManager.shared.updateOrder(order: orderModel, orderId: order?.orderId ?? "")
    }
}
