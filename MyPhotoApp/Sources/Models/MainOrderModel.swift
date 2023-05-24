//
//  MainOrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

struct MainOrderModel: Identifiable {
    let id: UUID
    let name: String
    let instagramLink: String?
    let place: String
    let price: Int?
    let date: Date
    let duration: Double
    let description: String?
    let imageUrl: String
}
