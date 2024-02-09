//
//  UserOrdersModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

struct DbOrderModel: Codable, Hashable {
    let orderId: String
    let orderCreateDate: Date
    let orderPrice: String?
    let orderStatus: String?
    let orderShootingDate: Date
    let orderShootingTime: [String]?
    let orderShootingDuration: String?
    let orderSamplePhotos: [String]?
    let orderMessages: Bool
    let newMessagesAuthor: Int
    let newMessagesCustomer: Int
    
    let authorId: String?
    let authorName: String?
    let authorSecondName: String?
    let authorLocation: String?
    let authorRegion: String?
    let customerId: String?
    let customerName: String?
    let customerSecondName: String?
    let customerDescription: String?
    let customerContactInfo: DbContactInfo

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderCreateDate = try container.decode(Date.self, forKey: .orderCreateDate)
        self.orderPrice = try container.decodeIfPresent(String.self, forKey: .orderPrice)
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
        self.orderShootingDate = try container.decode(Date.self, forKey: .orderShootingDate)
        self.orderShootingTime = try container.decodeIfPresent([String].self, forKey: .orderShootingTime)
        self.orderShootingDuration = try container.decodeIfPresent(String.self, forKey: .orderShootingDuration)
        self.orderMessages = try container.decode(Bool.self, forKey: .orderMessages)
        self.newMessagesAuthor = try container.decode(Int.self, forKey: .newMessagesAuthor)
        self.newMessagesCustomer = try container.decode(Int.self, forKey: .newMessagesCustomer)
        self.orderSamplePhotos = try container.decodeIfPresent([String].self, forKey: .orderSamplePhotos)

        self.authorId = try container.decodeIfPresent(String.self, forKey: .authorId)
        self.authorLocation = try container.decodeIfPresent(String.self, forKey: .authorLocation)
        self.authorRegion = try container.decodeIfPresent(String.self, forKey: .authorRegion)
        self.authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        self.authorSecondName = try container.decodeIfPresent(String.self, forKey: .authorSecondName)
        
        self.customerId = try container.decodeIfPresent(String.self, forKey: .customerId)
        self.customerName = try container.decodeIfPresent(String.self, forKey: .customerName)
        self.customerSecondName = try container.decodeIfPresent(String.self, forKey: .customerSecondName)
        self.customerDescription = try container.decodeIfPresent(String.self, forKey: .customerDescription)
        self.customerContactInfo = try container.decode(DbContactInfo.self, forKey: .customerContactInfo)
    }
    static func == (lhs: DbOrderModel, rhs: DbOrderModel) -> Bool {
        return lhs.orderId == rhs.orderId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
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
        case newMessagesAuthor = "new_messages_author"
        case newMessagesCustomer = "new_messages_customer"
        case authorId = "author_id"
        case authorLocation = "author_location"
        case authorRegion = "author_region"
        case authorName = "author_name"
        case authorSecondName = "author_second_name"
        
        case customerId = "customer_id"
        case customerName = "customer_name"
        case customerSecondName = "customer_second_name"
        case customerDescription = "customer_description"
        case customerContactInfo = "customer_contact_info"
        
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
        try container.encodeIfPresent(self.newMessagesAuthor, forKey: .newMessagesAuthor)
        try container.encodeIfPresent(self.newMessagesCustomer, forKey: .newMessagesCustomer)

        try container.encodeIfPresent(self.authorId, forKey: .authorId)
        try container.encodeIfPresent(self.authorName, forKey: .authorName)
        try container.encodeIfPresent(self.authorSecondName, forKey: .authorSecondName)
        try container.encodeIfPresent(self.authorLocation, forKey: .authorLocation)
        try container.encodeIfPresent(self.authorRegion, forKey: .authorRegion)

        try container.encodeIfPresent(self.customerId, forKey: .customerId)
        try container.encodeIfPresent(self.customerName, forKey: .customerName)
        try container.encodeIfPresent(self.customerSecondName, forKey: .customerSecondName)
        try container.encodeIfPresent(self.customerDescription, forKey: .customerDescription)
        try container.encodeIfPresent(self.customerContactInfo, forKey: .customerContactInfo)
        }
  
    init(order: OrderModel) {
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
        self.orderPrice = order.orderPrice
        
        self.customerId = order.customerId
        self.customerName = order.customerName
        self.customerSecondName = order.customerSecondName
        self.customerDescription = order.customerDescription
        self.customerContactInfo =  DbContactInfo(info: order.customerContactInfo)
        self.orderSamplePhotos = order.orderSamplePhotos
        self.orderMessages = order.orderMessages
        self.newMessagesAuthor = order.newMessagesAuthor
        self.newMessagesCustomer = order.newMessagesCustomer
        self.authorRegion = order.authorRegion
    }
    
}

struct DbContactInfo: Codable, Equatable, Hashable {
    let instagramLink: String?
    let phone: String?
    let email: String?
    
    init(info: ContactInfo) {
        self.instagramLink = info.instagramLink
        self.phone = info.phone
        self.email = info.email
    }
    
    init(instagramLink: String?, phone: String?, email: String?) {
        self.instagramLink = instagramLink
        self.phone = phone
        self.email = email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
    }
    enum CodingKeys: String, CodingKey {
        case instagramLink = "instagram_link"
        case phone = "phone"
        case email = "email"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(self.phone, forKey: .phone)
        try container.encodeIfPresent(self.email, forKey: .email)
    }
}

struct DbMessage: Codable, Equatable, Hashable {
    let dateCreate: Date
    let message: String?
    let isViewed: Bool
    let imageURL: String?
}
