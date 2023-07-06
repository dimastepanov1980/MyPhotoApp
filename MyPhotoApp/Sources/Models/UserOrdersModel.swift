//
//  UserOrdersModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

struct UserOrdersModel: Codable {

    let id: String
    let location: String?
    let name: String?
    let instagramLink: String?
    let price: String?
    let description: String?
    let date: Date
    let duration: String?
    let imageUrl: [String]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.date = try container.decode(Date.self, forKey: .date)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.imageUrl = try container.decodeIfPresent([String].self, forKey: .imageUrl)
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case location = "location"
        case name = "name"
        case instagramLink = "instagram_link"
        case price = "price"
        case description = "description"
        case date = "date"
        case duration = "duration"
        case imageUrl = "image_url"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.location, forKey: .location)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.duration, forKey: .duration)
        try container.encodeIfPresent(self.imageUrl, forKey: .imageUrl)
    }
    /*
    init(id: String,
         location: String?,
         name: String?, instagramLink: String?, price: String?, description: String?, date: Date?, duration: String?, imageUrl: [String]?)
     */
  
    init(order: OrderModel) {
        self.id = order.orderId
        self.location = order.location
        self.name = order.name
        self.instagramLink = order.instagramLink
        self.price = order.price
        self.description = order.description
        self.date = order.date
        self.duration = order.duration
        self.imageUrl = order.imageUrl
    }

}
