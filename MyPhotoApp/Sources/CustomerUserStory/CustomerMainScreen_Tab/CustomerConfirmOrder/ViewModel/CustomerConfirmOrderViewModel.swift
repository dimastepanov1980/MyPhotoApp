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
    
    @Published var user: DBUserModel?
    @Published var customerFirstName: String
    @Published var customerSecondName: String
    
    @Published var customerInstagramLink: String
    @Published var customerPhone: String
    @Published var customerEmail: String
    
    @Published var authorId: String
    @Published var authorName: String
    @Published var authorSecondName: String
    @Published var location: String
    @Published var orderDate: Date
    @Published var orderTime: [String]
    @Published var orderDuration: String
    @Published var orderPrice: String
    @Published var regionAuthor: String
    @Published var orderDescription: String?
    
    init(user: DBUserModel? = nil, author: AuthorPortfolioModel, orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String) {
        self.authorId = author.id
        self.authorName = author.author?.nameAuthor ?? ""
        self.authorSecondName = author.author?.familynameAuthor ?? ""
        self.location = author.author?.location ?? ""
        self.orderDate = orderDate
        self.orderTime = orderTime
        self.orderDuration = orderDuration
        self.orderPrice = orderPrice
        self.regionAuthor = author.author?.regionAuthor ?? ""
        
        self.customerFirstName = user?.firstName ?? ""
        self.customerSecondName = user?.secondName ?? ""
        self.customerInstagramLink = user?.instagramLink ?? ""
        self.customerPhone = user?.phone ?? ""
        self.customerEmail = user?.email ?? ""
        
        Task{
         try await getCustomerData()
        }
    }
    func getCustomerData() async throws{
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        let customer = try await UserManager.shared.getUser(userId: userDataResult.uid)
        self.customerFirstName = customer.firstName ?? ""
        self.customerSecondName = customer.secondName ?? ""
        self.customerInstagramLink = customer.instagramLink ?? ""
        self.customerEmail = customer.email ?? ""
        self.customerPhone = customer.phone ?? ""
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
                                               customerName: customerFirstName,
                                               customerSecondName: customerSecondName,
                                               customerDescription: orderDescription,
                                               customerContactInfo: DbContactInfo(instagramLink: customerInstagramLink, phone: customerPhone, email: customerEmail))
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
