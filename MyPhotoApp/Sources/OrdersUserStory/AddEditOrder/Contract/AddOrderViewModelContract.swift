//
//  AddOrderViewModelContract.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

@MainActor
protocol AddOrderViewModelType: ObservableObject {
    var name: String { get set }
    var instagramLink: String { get set }
    var price: String { get set }
    var place: String { get set }
    var description: String { get set }
    var date: Date { get set }
    var duration: String { get set }
    var imageUrl: [String] { get set }
    var order: UserOrdersModel { get set }
    
    func addOrder(order: UserOrdersModel) async throws
    func updateOrder() async throws
    
}