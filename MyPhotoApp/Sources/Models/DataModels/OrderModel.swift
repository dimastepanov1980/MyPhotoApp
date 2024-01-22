//
//  OrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation


struct OrderModel: Hashable, Equatable {
    var orderId: String
    var orderCreateDate: Date
    var orderPrice: String?
    var orderStatus: String
    var orderShootingDate: Date
    var orderShootingTime: [String]?
    var orderShootingDuration: String
    var orderSamplePhotos: [String]
    var orderMessages: Bool
    var newMessagesAuthor: Int
    var newMessagesCustomer: Int
    
    var authorId: String?
    var authorName: String?
    var authorSecondName: String?
    var authorLocation: String?
    var authorRegion: String?
    
    var customerId: String?
    var customerName: String?
    var customerSecondName: String?
    var customerDescription: String?
    var customerContactInfo: ContactInfo
    
    init(orderId: String, orderCreateDate: Date, orderPrice: String? = nil, orderStatus: String, orderShootingDate: Date, orderShootingTime: [String]? = nil, orderShootingDuration: String, orderSamplePhotos: [String], orderMessages: Bool, newMessagesAuthor: Int, newMessagesCustomer: Int, authorId: String? = nil, authorName: String? = nil, authorSecondName: String? = nil, authorLocation: String? = nil, authorRegion: String? = nil, customerId: String? = nil, customerName: String? = nil, customerSecondName: String? = nil, customerDescription: String? = nil, customerContactInfo: ContactInfo) {
        self.orderId = orderId
        self.orderCreateDate = orderCreateDate
        self.orderPrice = orderPrice
        self.orderStatus = orderStatus
        self.orderShootingDate = orderShootingDate
        self.orderShootingTime = orderShootingTime
        self.orderShootingDuration = orderShootingDuration
        self.orderSamplePhotos = orderSamplePhotos
        self.orderMessages = orderMessages
        self.newMessagesAuthor = newMessagesAuthor
        self.newMessagesCustomer = newMessagesCustomer
        self.authorId = authorId
        self.authorName = authorName
        self.authorSecondName = authorSecondName
        self.authorLocation = authorLocation
        self.authorRegion = authorRegion
        self.customerId = customerId
        self.customerName = customerName
        self.customerSecondName = customerSecondName
        self.customerDescription = customerDescription
        self.customerContactInfo = customerContactInfo
    }
    init(order: DbOrderModel) {
        self.orderId = order.orderId
        self.orderCreateDate = order.orderCreateDate
        self.orderPrice = order.orderPrice
        self.orderStatus = order.orderStatus ?? ""
        self.orderShootingDate = order.orderShootingDate
        self.orderShootingTime = order.orderShootingTime
        self.orderShootingDuration = order.orderShootingDuration ?? ""
        self.orderSamplePhotos = order.orderSamplePhotos ?? []
        self.orderMessages = order.orderMessages
        self.newMessagesAuthor = order.newMessagesAuthor
        self.newMessagesCustomer = order.newMessagesCustomer
        self.authorId = order.authorId
        self.authorName = order.authorName
        self.authorSecondName = order.authorSecondName
        self.authorLocation = order.authorLocation
        self.authorRegion = order.authorRegion
        self.customerId = order.customerId
        self.customerName = order.customerName
        self.customerSecondName = order.customerSecondName
        self.customerDescription = order.customerDescription
        self.customerContactInfo = ContactInfo(info: order.customerContactInfo)
    }
    
    static func == (lhs: OrderModel, rhs: OrderModel) -> Bool {
        return lhs.orderId == rhs.orderId
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
    }
}

struct ContactInfo {
    var instagramLink: String?
    var phone: String?
    var email: String?
    
    init(instagramLink: String? = nil, phone: String? = nil, email: String? = nil) {
        self.instagramLink = instagramLink
        self.phone = phone
        self.email = email
    }
    init(info: DbContactInfo) {
        self.instagramLink = info.instagramLink
        self.phone = info.phone
        self.email = info.email
    }
    
}


