//
//  OrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation


struct OrderModel {
    var orderId: String
    var orderCreateDate: Date
    var orderPrice: String?
    var orderStatus: String
    var orderShootingDate: Date
    var orderShootingTime: [String]?
    var orderShootingDuration: String
    var orderSamplePhotos: [String]
    var orderMessages: [DbMessage]?
    
    var authorId: String?
    var authorName: String?
    var authorSecondName: String?
    var authorLocation: String?
    var authorRegion: String?
    
    var customerId: String?
    var customerName: String?
    var customerSecondName: String?
    var customerDescription: String?
    var customerContactInfo: DbContactInfo

}


