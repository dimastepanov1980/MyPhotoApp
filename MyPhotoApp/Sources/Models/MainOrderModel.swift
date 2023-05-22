//
//  MainOrderModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

struct MainOrderModel: Identifiable {
    let id: String = UUID().uuidString
    let userId: String
    let name: String
    let place: String
    let date: Date
    let duration: Double
    let imageUrl: String
}
