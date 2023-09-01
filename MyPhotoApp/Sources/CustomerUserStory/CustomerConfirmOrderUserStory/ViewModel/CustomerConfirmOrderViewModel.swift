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
    
    @Published var authorName: String
    @Published var familynameAuthor: String
    @Published var authorRegion: String
    @Published var authorCity: String
    @Published var orderDate: Date
    @Published var orderTime: [String]
    @Published var orderDuration: String
    @Published var orderPrice: String
    @Binding var orderDescription: String
    
    init(author: AuthorPortfolioModel, orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String, orderDescription: Binding<String>) {
        self.authorName = author.author?.nameAuthor ?? ""
        self.familynameAuthor = author.author?.familynameAuthor ?? ""
        self.authorRegion = author.author?.countryCode ?? ""
        self.authorCity = author.author?.city ?? ""
        self.orderDate = orderDate
        self.orderTime = orderTime
        self.orderDuration = orderDuration
        self.orderPrice = orderPrice
        self._orderDescription = orderDescription
    }
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
}
