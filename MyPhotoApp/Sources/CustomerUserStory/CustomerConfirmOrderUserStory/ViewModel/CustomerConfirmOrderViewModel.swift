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
//    @Published var itemOrder: CustomerOrdersModel?
    
    @Published var authorName: String
    @Published var familynameAuthor: String
    @Published var location: String
    @Published var orderDate: Date
    @Published var orderTime: [String]
    @Published var orderDuration: String
    @Published var orderPrice: String
    @Published var regionAuthor: String
    @Binding var orderDescription: String
    
    init(author: AuthorPortfolioModel, orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String, regionAuthor: String, orderDescription: Binding<String>) {
        self.authorName = author.author?.nameAuthor ?? ""
        self.familynameAuthor = author.author?.familynameAuthor ?? ""
        self.location = author.author?.location ?? ""
        self.orderDate = orderDate
        self.orderTime = orderTime
        self.orderDuration = orderDuration
        self.orderPrice = orderPrice
        self.regionAuthor = regionAuthor
        self._orderDescription = orderDescription
    }
    
    func createNewOrder() async throws {
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        let customer = try await UserManager.shared.getUser(userId: userDataResult.uid)

//        let orderData: CustomerOrdersModel = CustomerOrdersModel(orderId: UUID().uuidString,
//                                                                 orderCreateDate: Date(),
//                                                                 orderPrice: orderPrice,
//                                                                 orderStatus: "upcoming",
//                                                                 orderShootingDate: orderDate,
//                                                                 orderShootingTime: orderTime,
//                                                                 orderShootingDuration: orderDuration,
//                                                                 orderShootingPlace: nil,
//                                                                 orderSamplePhotos: nil,
//                                                                 orderMessages: nil,
//                                                                 customerId: userDataResult.uid,
//                                                                 customerName: customer,
//                                                                 customerSecondName: <#T##String?#>,
//                                                                 customerDescription: <#T##String?#>,
//                                                                 customerContactInfo: <#T##ContactInfo?#>,
//                                                                 authorId: <#T##String#>,
//                                                                 authorName: <#T##String#>,
//                                                                 authorSecondName: <#T##String#>,
//                                                                 authorLocation: <#T##String?#>)
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
