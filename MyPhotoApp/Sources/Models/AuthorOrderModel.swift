//
//  OrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation


struct AuthorOrderModel {
    let orderId: String
    let orderCreateDate: Date
    let orderPrice: String?
    let orderStatus: String
    let orderShootingDate: Date
    let orderShootingTime: [String]?
    let orderShootingDuration: String
    let orderSamplePhotos: [String]
    let orderMessages: [DbMessage]?
    
    let authorId: String?
    let authorName: String?
    let authorSecondName: String?
    let authorLocation: String?
    
    let customerId: String?
    let customerName: String?
    let customerSecondName: String?
    let customerDescription: String?
    
    
    let instagramLink: String?
    
}

