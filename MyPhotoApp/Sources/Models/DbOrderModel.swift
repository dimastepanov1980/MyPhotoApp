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
    let orderPrice: String?
    let orderStatus: String?
    let orderShootingDate: Date
    let orderShootingTime: [String]?
    let orderShootingDuration: String?
    let orderSamplePhotos: [String]?
    let orderMessages: [DbMessage]?
    
    let authorId: String?
    let authorName: String?
    let authorSecondName: String?
    let authorLocation: String?

    
    let instagramLink: String?
    let description: String?

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderCreateDate = try container.decode(Date.self, forKey: .orderCreateDate)
        self.orderPrice = try container.decodeIfPresent(String.self, forKey: .orderPrice)
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
        self.orderShootingDate = try container.decode(Date.self, forKey: .orderShootingDate)
        self.orderShootingTime = try container.decodeIfPresent([String].self, forKey: .orderShootingTime)
        self.orderShootingDuration = try container.decodeIfPresent(String.self, forKey: .orderShootingDuration)
        self.orderMessages = try container.decodeIfPresent([DbMessage].self, forKey: .orderMessages)
        self.orderSamplePhotos = try container.decodeIfPresent([String].self, forKey: .orderSamplePhotos)

        self.authorId = try container.decodeIfPresent(String.self, forKey: .authorId)
        self.authorLocation = try container.decodeIfPresent(String.self, forKey: .authorLocation)
        self.authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        self.authorSecondName = try container.decodeIfPresent(String.self, forKey: .authorSecondName)
        
        
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCreateDate = "order_create_date"
        case orderPrice = "order_price"
        case orderStatus = "order_status"
        case orderShootingDate = "order_shooting_date"
        case orderShootingTime = "order_shooting_time"
        case orderShootingDuration = "order_shooting_duration"
        case orderSamplePhotos = "order_sample_photos"
        case orderMessages = "order_messages"


        case authorId = "author_id"
        case authorLocation = "author_location"
        case authorName = "author_name"
        case authorSecondName = "author_second_name"
        case instagramLink = "instagram_link"
     
        case description = "description"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.orderId, forKey: .orderId)
        try container.encode(self.orderCreateDate, forKey: .orderCreateDate)
        try container.encodeIfPresent(self.orderPrice, forKey: .orderPrice)
        try container.encodeIfPresent(self.orderStatus, forKey: .orderStatus)
        try container.encodeIfPresent(self.orderShootingDate, forKey: .orderShootingDate)
        try container.encodeIfPresent(self.orderShootingTime, forKey: .orderShootingTime)
        try container.encodeIfPresent(self.orderShootingDuration, forKey: .orderShootingDuration)
        try container.encodeIfPresent(self.orderSamplePhotos, forKey: .orderSamplePhotos)
        try container.encodeIfPresent(self.orderMessages, forKey: .orderMessages)

        try container.encodeIfPresent(self.authorId, forKey: .authorId)
        try container.encodeIfPresent(self.authorName, forKey: .authorName)
        try container.encodeIfPresent(self.authorSecondName, forKey: .authorSecondName)
        try container.encodeIfPresent(self.authorLocation, forKey: .authorLocation)

        try container.encodeIfPresent(self.instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(self.description, forKey: .description)


    }
  
    init(order: AuthorOrderModel) {
        self.orderId = order.orderId
        self.orderCreateDate = order.orderCreateDate
        self.orderStatus = order.orderStatus
        self.orderShootingDate = order.orderShootingDate
        self.orderShootingTime = order.orderShootingTime
        self.orderShootingDuration = order.orderShootingDuration
        
        self.authorId = order.authorId
        self.authorName = order.authorName
        self.authorSecondName = order.authorSecondName
        self.authorLocation = order.authorLocation
        
        self.instagramLink = order.instagramLink
        self.orderPrice = order.orderPrice
        self.description = order.description
    
        self.orderSamplePhotos = order.orderSamplePhotos
        self.orderMessages = order.orderMessages
    }
    
}


struct DbMessage: Codable {
    let dateCreate: Date
    let message: String?
    let isViewed: Bool
    let imageURL: String?
}
