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

    
    let name: String?
    let instagramLink: String?
    let location: String?
    let description: String?
    let date: Date
    let duration: String
    let imageUrl: [String]
}

