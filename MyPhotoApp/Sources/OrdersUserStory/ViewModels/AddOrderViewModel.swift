//
//  AddOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

@MainActor
final class AddOrderViewModel: AddOrderViewModelType {
    @Published var name: String = ""
    @Published var instagramLink: String = ""
    @Published var price: String = ""
    @Published var place: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    func addOrder(order: UserOrdersModel) async throws {
                let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.addNewOrder(userId: authDateResult.uid, order: order)
    }
}
