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

    private let order: UserOrdersModel

    init(order: UserOrdersModel) {
        self.order = order
        updatePreview()
    }
    
    func updatePreview() {
        name = order.name ?? ""
        instagramLink = order.instagramLink ?? ""
        price = order.price ?? ""
        place = order.location ?? ""
        description = order.description ?? ""
        duration = order.duration ?? ""
        imageUrl = order.imageUrl ?? []
        date = order.date ?? Date()
    }
    
    func addOrder(order: UserOrdersModel) async throws {
                let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.addNewOrder(userId: authDateResult.uid, order: order)
    }
   
    
    
    
}

/*
 
 
 let userOrders = UserOrdersModel(order: OrderModel(orderId: UUID().uuidString,
                                                    name: viewModel.name,
                                                    instagramLink: viewModel.instagramLink,
                                                    price: viewModel.price,
                                                    location: viewModel.place,
                                                    description: viewModel.description,
                                                    date: viewModel.date,
                                                    duration: viewModel.duration,
                                                    imageUrl: viewModel.imageUrl))
 
 */
