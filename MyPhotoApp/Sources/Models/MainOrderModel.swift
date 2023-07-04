//
//  MainOrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

struct MainOrderModel: Identifiable {
    let id: String
    let name: String
    let instagramLink: String?
    let place: String
    let price: String?
    let date: Date
    let duration: String
    let description: String?
    let imageUrl: [String]
    
    init(order: UserOrdersModel){
        self.id = order.id
        self.name = order.name ?? ""
        self.instagramLink = order.instagramLink
        self.place = order.location ?? ""
        self.price = order.price
        self.date = order.date ?? Date()
        self.duration = order.duration ?? ""
        self.description = order.description
        self.imageUrl = order.imageUrl ?? []
    }
    
    init(id: String, name: String, instagramLink: String?,
         place: String, price: String?, date: Date, duration: String,
         description: String?, imageUrl: [String]){
        self.id = id
        self.name = name
        self.instagramLink = instagramLink
        self.place = place
        self.price = price
        self.date = date
        self.duration = duration
        self.description = description
        self.imageUrl = imageUrl
    }
}
