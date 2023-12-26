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
    var user: DBUserModel?
    
    @Published var titleStatus: String?
    @Published var messageStatus: String?
    @Published var buttonTitleStatus: String?
    
    @Published var showOrderStatusAlert: Bool = false
    @Published var customerFirstName: String
    @Published var customerSecondName: String
    @Published var customerInstagramLink: String
    @Published var customerPhone: String
    @Published var customerEmail: String
    
    @Published var authorId: String
    @Published var authorName: String
    @Published var authorSecondName: String
    @Published var authorBookingDays: [String : [String]]

    @Published var location: String
    @Published var orderDate: Date
    @Published var orderTime: [String]
    @Published var orderDuration: String
    @Published var orderPrice: String
    @Published var regionAuthor: String
    @Published var orderDescription: String?
    
    init(user: DBUserModel? = nil, authorId: String, authorName: String, authorSecondName: String, location: String, regionAuthor : String, authorBookingDays: [String : [String]], orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String) {
        self.authorId = authorId
        self.authorName = authorName
        self.authorSecondName = authorSecondName
        self.location = location
        self.orderDate = orderDate
        self.orderTime = orderTime
        self.orderDuration = orderDuration
        self.orderPrice = orderPrice
        self.regionAuthor = regionAuthor
        
        self.customerFirstName = user?.firstName ?? ""
        self.customerSecondName = user?.secondName ?? ""
        self.authorBookingDays = authorBookingDays
        self.customerInstagramLink = user?.instagramLink ?? ""
        self.customerPhone = user?.phone ?? ""
        self.customerEmail = user?.email ?? ""
        
        Task{
         try await getCustomerData()
        }
    }
    func getCustomerData() async throws -> Bool{
        do {
            let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
            let customer = try await UserManager.shared.getUser(userId: userDataResult.uid)
            self.customerFirstName = customer.firstName ?? ""
            self.customerSecondName = customer.secondName ?? ""
            self.customerInstagramLink = customer.instagramLink ?? ""
            self.customerEmail = customer.email ?? ""
            self.customerPhone = customer.phone ?? ""
            return false
            
        } catch {
            return true
        }
 
    }
    func createNewOrder() async throws {
        var successBooking: Bool = false
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
                                               customerContactInfo: ContactInfo(instagramLink: customerInstagramLink, phone: customerPhone, email: customerEmail))
        
        // Make new request for chek actual booking date
        let actualBookingDateRequest = try await UserManager.shared.getUserPortfolio(userId: authorId)
        let stringDayToCheck = formattedDate(date: orderDate, format: "YYYYMMdd")
        
        if let actualBookingDays = actualBookingDateRequest.bookingDays{
            print(actualBookingDays)
            
            if let existingTime = actualBookingDays[stringDayToCheck] {
    
                let existingTimeSet = Set(existingTime)
                let newTimeSet = Set(orderTime)
                
                let commonTime = existingTimeSet.intersection(newTimeSet)

                if commonTime.isEmpty {
                    print("Selected Time'\(orderTime)' does not exist and can be Booking Now.")
                    for time in orderTime {
                        try await UserManager.shared.addTimeSlotForBookingDay(userId: authorId, selectedDay: stringDayToCheck, selectedTime: time )
                    }
                    successBooking = true
                } else {
                    self.titleStatus = R.string.localizable.order_fail()
                    self.messageStatus = R.string.localizable.order_created_message_fail()
                    self.buttonTitleStatus = R.string.localizable.order_created_button_fail()
                    print("Error! The selected time exists, please select another time or date.")
                }
                
                
            } else {
                print("Selected Day \(stringDayToCheck)' does not exist and can be Booking Now.")
                try await UserManager.shared.addNewBookingDays(userId: authorId, selectedDay: stringDayToCheck, selectedTimes: orderTime)
                successBooking = true
            }
        } else {
            print("Success! But We are unable to verify the available time slot and date.")
            try await UserManager.shared.addNewBookingDays(userId: authorId, selectedDay: stringDayToCheck, selectedTimes: orderTime)
            successBooking = true
        }
        
        if successBooking {
            self.titleStatus = R.string.localizable.order_created()
            self.messageStatus = R.string.localizable.order_created_message()
            self.buttonTitleStatus = R.string.localizable.order_created_button()
            print("Success! You have booked the selected date and time.")
            try await UserManager.shared.addNewOrder(userId: userDataResult.uid, order: DbOrderModel(order: orderData))
        }
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
