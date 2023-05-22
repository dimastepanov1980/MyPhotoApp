//
//  MainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

protocol MainScreenViewModelType: ObservableObject {
    var userId: String { get }
    var name: String { get }
    var place: String? { get }
    var date: Date { get }
    var duration: Double { get }
    var imageUrl: String { get }
    var weaterId: String { get }
    var orders: [MainOrderModel] { get }
    
    func createOrder()
    func formattedDate(date: Date) -> String
    
}
