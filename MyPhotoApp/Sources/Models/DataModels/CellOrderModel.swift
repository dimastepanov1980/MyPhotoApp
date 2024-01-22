//
//  CellOrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/15/24.
//

import Foundation

struct CellOrderModel {
    var orderPrice: String
    var orderStatus: String
    var orderShootingDate: Date
    var orderShootingTime: String
    var orderShootingDuration: String
    var newMessagesAuthor: Int
    var newMessagesCustomer: Int
    
    var authorName: String
    var authorSecondName: String
    var authorLocation: String
    
    var customerName: String
    var customerSecondName: String
    var customerDescription: String
    
    
    init(order: OrderModel) {
        self.orderPrice = order.orderPrice ?? ""
        self.orderStatus = order.orderStatus
        self.orderShootingDate = order.orderShootingDate
        self.orderShootingTime = order.orderShootingTime?.first ?? "" 
        self.orderShootingDuration = order.orderShootingDuration
        self.newMessagesAuthor = order.newMessagesAuthor
        self.newMessagesCustomer = order.newMessagesCustomer
        self.authorName = order.authorName ?? ""
        self.authorSecondName = order.authorSecondName ?? ""
        self.authorLocation = order.authorLocation ?? ""
        self.customerName = order.customerName ?? ""
        self.customerSecondName = order.customerSecondName ?? ""
        self.customerDescription = order.customerDescription ?? ""
    }
    
    init(orderPrice: String, orderStatus: String, orderShootingDate: Date, orderShootingTime: String, orderShootingDuration: String, newMessagesAuthor: Int, newMessagesCustomer: Int, authorName: String, authorSecondName: String, authorLocation: String, customerName: String, customerSecondName: String, customerDescription: String) {
        self.orderPrice = orderPrice
        self.orderStatus = orderStatus
        self.orderShootingDate = orderShootingDate
        self.orderShootingTime = orderShootingTime
        self.orderShootingDuration = orderShootingDuration
        self.newMessagesAuthor = newMessagesAuthor
        self.newMessagesCustomer = newMessagesCustomer
        self.authorName = authorName
        self.authorSecondName = authorSecondName
        self.authorLocation = authorLocation
        self.customerName = customerName
        self.customerSecondName = customerSecondName
        self.customerDescription = customerDescription
    }
}

