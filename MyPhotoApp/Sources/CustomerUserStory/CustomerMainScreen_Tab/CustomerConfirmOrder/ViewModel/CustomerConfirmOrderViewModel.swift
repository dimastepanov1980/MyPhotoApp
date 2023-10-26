//
//  CustomerConfirmOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/28/23.
//

import Foundation
import SwiftUI

@MainActor
final class CustomerConfirmOrderViewModel: CustomerConfirmOrderViewModelType {
    
    var authorId: String
    var authorName: String
    var authorSecondName: String
    var location: String
    var orderDate: Date
    var orderTime: [String]
    var orderDuration: String
    var orderPrice: String
    var regionAuthor: String
    var orderDescription: String?
    
    init(author: AuthorPortfolioModel, orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String) {
        self.authorId = author.id
        self.authorName = author.author?.nameAuthor ?? ""
        self.authorSecondName = author.author?.familynameAuthor ?? ""
        self.location = author.author?.location ?? ""
        self.orderDate = orderDate
        self.orderTime = orderTime
        self.orderDuration = orderDuration
        self.orderPrice = orderPrice
        self.regionAuthor = author.author?.regionAuthor ?? ""
    }
    
    func createNewOrder() async throws {
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        let customer = try await UserManager.shared.getUser(userId: userDataResult.uid)

        let orderData: OrderModel = OrderModel(orderId: UUID().uuidString,
                                               orderCreateDate: Date(),
                                               orderPrice: orderPrice,
                                               orderStatus: "upcoming",
                                               orderShootingDate: orderDate,
                                               orderShootingTime: orderTime,
                                               orderShootingDuration: orderDuration,
                                               orderSamplePhotos: [],
                                               orderMessages: [],
                                               authorId: authorId,
                                               authorName: authorName,
                                               authorSecondName: authorSecondName,
                                               authorLocation: location,
                                               authorRegion: regionAuthor,
                                               customerId: customer.userId,
                                               customerName: customer.firstName,
                                               customerSecondName: customer.secondName,
                                               customerDescription: orderDescription,
                                               customerContactInfo: DbContactInfo(instagramLink: customer.instagramLink, phone: customer.phone, email: customer.email))
        print(orderData)
        try await UserManager.shared.addNewOrder(userId: userDataResult.uid, order: DbOrderModel(order: orderData))
    }
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
    
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
}
