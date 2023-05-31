//
//  OrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation

struct OrderModel {
    let orderId: String
    let name: String?
    let instagramLink: String?
    let price: Int?
    let location: String?
    let description: String?
    let date: Date
    let duration: Double
}
