//
//  UserOrdersModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

struct DbOrderModel: Codable {

    let orderId: String
    let orderCreateDate: Date
    
    
    let location: String?
    let name: String?
    let instagramLink: String?
    let orderPrice: String?
    let description: String?
    let date: Date
    let duration: String?
    let imageUrl: [String]?
    let orderStatus: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderCreateDate = try container.decode(Date.self, forKey: .orderCreateDate)
        self.orderPrice = try container.decodeIfPresent(String.self, forKey: .orderPrice)

        
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.date = try container.decode(Date.self, forKey: .date)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.imageUrl = try container.decodeIfPresent([String].self, forKey: .imageUrl)
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
    }

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCreateDate = "order_create_date"
        case orderPrice = "order_price"

        case location = "location"
        case name = "name"
        case instagramLink = "instagram_link"
     
        case description = "description"
        case date = "date"
        case duration = "duration"
        case imageUrl = "image_url"
        case orderStatus = "order_status"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.orderId, forKey: .orderId)
        try container.encode(self.orderCreateDate, forKey: .orderCreateDate)
        try container.encodeIfPresent(self.orderPrice, forKey: .orderPrice)

        
        try container.encodeIfPresent(self.location, forKey: .location)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.duration, forKey: .duration)
        try container.encodeIfPresent(self.imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(self.orderStatus, forKey: .orderStatus)

    }
  
    init(order: AuthorOrderModel) {
        self.orderId = order.orderId
        self.orderCreateDate = order.orderCreateDate
        self.location = order.location
        self.name = order.name
        self.instagramLink = order.instagramLink
        self.orderPrice = order.orderPrice
        self.description = order.description
        self.date = order.date
        self.duration = order.duration
        self.imageUrl = order.imageUrl
        self.orderStatus = order.orderStatus
    }
}
