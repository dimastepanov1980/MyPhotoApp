//
//  MainOrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

struct MainOrderModel: Identifiable {
    let id: UUID
    let name: String
    let instagramLink: String?
    let place: String
    let price: Int?
    let date: Date
    let duration: Double
    let description: String?
    let imageUrl: String
    
//    init(order: UserOrders){
//        self.id = order.id
//        self.name = order.name
//        self.instagramLink = order.instagramLink
//        self.place = order.location
//        self.price = order.price
//        self.date = order.date
//        self.duration = order.duration
//        self.description = order.description
//        self.imageUrl = order.imageUrl
//    }
}
