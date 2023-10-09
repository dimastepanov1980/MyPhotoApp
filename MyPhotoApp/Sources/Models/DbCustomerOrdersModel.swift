//
//  CustomerOrdersModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/8/23.
//

import Foundation

struct DbCustomerOrdersModel: Codable {
    
// MARK: - Order information
    let orderId: String //
    let orderCreateDate: Date
    let orderPrice: String?
    let orderStatus: String?
    let orderShootingDate: Date
    let orderShootingTime: [String]?
    let orderShootingDuration: String?
    let orderShootingPlace: String?
    let orderSamplePhotos: [String]?
    let orderMessages: [DbMessage]?

// MARK: - Customer information
    let customerId: String
    let customerName: String?
    let customerSecondName: String?
    let customerDescription: String?
    let customerContactInfo: ContactInfo?

// MARK: - Author information
    let authorId: String
    let authorName: String
    let authorSecondName: String
    let authorLocation: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderCreateDate = try container.decode(Date.self, forKey: .orderCreateDate)
        self.orderPrice = try container.decodeIfPresent(String.self, forKey: .orderPrice)
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
        self.orderShootingDate = try container.decode(Date.self, forKey: .orderShootingDate)
        self.orderShootingTime = try container.decodeIfPresent([String].self, forKey: .orderShootingTime)
        self.orderShootingDuration = try container.decodeIfPresent(String.self, forKey: .orderShootingDuration)
        self.orderShootingPlace = try container.decodeIfPresent(String.self, forKey: .orderShootingPlace)
        self.orderSamplePhotos = try container.decodeIfPresent([String].self, forKey: .orderSamplePhotos)
        self.orderMessages = try container.decodeIfPresent([DbMessage].self, forKey: .orderMessages)
        self.customerId = try container.decode(String.self, forKey: .customerId)
        self.customerName = try container.decodeIfPresent(String.self, forKey: .customerName)
        self.customerSecondName = try container.decodeIfPresent(String.self, forKey: .customerSecondName)
        self.customerDescription = try container.decodeIfPresent(String.self, forKey: .customerDescription)
        self.customerContactInfo = try container.decodeIfPresent(ContactInfo.self, forKey: .customerContactInfo)
        self.authorId = try container.decode(String.self, forKey: .authorId)
        self.authorName = try container.decode(String.self, forKey: .authorName)
        self.authorSecondName = try container.decode(String.self, forKey: .authorSecondName)
        self.authorLocation = try container.decodeIfPresent(String.self, forKey: .authorLocation)
    }
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCreateDate = "order_create_date"
        case orderPrice = "order_price"
        case orderStatus = "order_status"
        case orderShootingDate = "order_shooting_date"
        case orderShootingTime = "order_shooting_time"
        case orderShootingDuration = "order_shooting_duration"
        case orderShootingPlace = "order_shooting_place"
        case orderSamplePhotos = "order_sample_photos"
        case orderMessages = "order_messages"
        case customerId = "customer_id"
        case customerName = "customer_name"
        case customerSecondName = "customer_second_name"
        case customerDescription = "customer_description"
        case customerContactInfo = "customer_contact_info"
        case authorId = "author_id"
        case authorName = "author_name"
        case authorSecondName = "author_second_name"
        case authorLocation = "author_location"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.orderId, forKey: .orderId)
        try container.encode(self.orderCreateDate, forKey: .orderCreateDate)
        try container.encodeIfPresent(self.orderPrice, forKey: .orderPrice)
        try container.encodeIfPresent(self.orderStatus, forKey: .orderStatus)
        try container.encode(self.orderShootingDate, forKey: .orderShootingDate)
        try container.encodeIfPresent(self.orderShootingTime, forKey: .orderShootingTime)
        try container.encodeIfPresent(self.orderShootingDuration, forKey: .orderShootingDuration)
        try container.encodeIfPresent(self.orderShootingPlace, forKey: .orderShootingPlace)
        try container.encodeIfPresent(self.orderSamplePhotos, forKey: .orderSamplePhotos)
        try container.encodeIfPresent(self.orderMessages, forKey: .orderMessages)
        try container.encode(self.customerId, forKey: .customerId)
        try container.encodeIfPresent(self.customerName, forKey: .customerName)
        try container.encodeIfPresent(self.customerSecondName, forKey: .customerSecondName)
        try container.encodeIfPresent(self.customerDescription, forKey: .customerDescription)
        try container.encodeIfPresent(self.customerContactInfo, forKey: .customerContactInfo)
        try container.encode(self.authorId, forKey: .authorId)
        try container.encode(self.authorName, forKey: .authorName)
        try container.encode(self.authorSecondName, forKey: .authorSecondName)
        try container.encodeIfPresent(self.authorLocation, forKey: .authorLocation)
    }
}

struct DbMessage: Codable {
    let dateCreate: Date
    let message: String?
    let isViewed: Bool
    let imageURL: String?
}

struct ContactInfo: Codable {
    let instagramLink: String?
    let phone: String?
    let email: String?
}

