//
//  CustomerConfirmOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/28/23.
//

import Foundation
import SwiftUI

@MainActor
protocol CustomerConfirmOrderViewModelType: ObservableObject {
    var user: DBUserModel? { get }
    var customerFirstName: String { get }
    var customerSecondName: String { get }
    var customerInstagramLink: String { get set }
    var customerPhone: String { get set }
    var customerEmail: String { get set }
    
    var authorName: String { get }
    var authorSecondName: String { get }
    var authorBookingDays: [BookingDay] { get set }
    var location: String { get }
    var orderDate: Date { get }
    var orderTime: [String] { get }
    var orderDuration: String { get }
    var orderDescription: String? { get set }
    var orderPrice: String { get }
    var regionAuthor: String { get }

    
    func formattedDate(date: Date, format: String) -> String
    func sortedDate(array: [String]) -> [String]
    func currencySymbol(for regionCode: String) -> String
    func createNewOrder() async throws
    func getCustomerData() async throws

}

