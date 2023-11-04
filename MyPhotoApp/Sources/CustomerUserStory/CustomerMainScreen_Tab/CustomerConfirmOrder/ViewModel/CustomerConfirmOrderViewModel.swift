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
    @Published var authorBookingDays: [BookingDay]

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
        self.authorBookingDays = author.bookingDays ?? []
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
                                               customerContactInfo: DbContactInfo(instagramLink: customerInstagramLink, phone: customerPhone, email: customerEmail))
        var bookingDayToCheck: BookingDay = BookingDay(date: orderDate,
                                                       time: orderTime,
                                                       dayOff: false)
        // Make new request for chek actual booking date
        var actualBookingDateRequest = try await UserManager.shared.getUserPortfolio(userId: authorId)
        var existingDayForRemove: BookingDay?
         
         
        if var actualBookingDays = actualBookingDateRequest.bookingDays{
            let bookingDay = formattedDate(date: bookingDayToCheck.date, format: "dd MMMM YYYY")
            
            if actualBookingDays.contains(where: { formattedDate(date: $0.date, format: "dd MMMM YYYY") == bookingDay }) {
                print("Date is existing!")
                actualBookingDays = actualBookingDays.map { existingDay in
                    
                    if formattedDate(date: existingDay.date, format: "dd MMMM YYYY") == formattedDate(date: bookingDayToCheck.date, format: "dd MMMM YYYY") {
                        
                        var updatedDay = existingDay
                        if bookingDayToCheck.time.allSatisfy({ existingDay.time.contains($0) }) {
                            print("Error Time is existing: \(existingDay)!!!!!!!!!!!!!!!!!!!!!")
                            // Return to Detail screen and update time Slot and show error "select time is not aveible now"
                            self.authorBookingDays = actualBookingDays
                            successBooking = false
                            return existingDay
                        } else {
                            print("No Time contains neet to Add for existing day new time!!!!!!!!!!!!!!!!!!!!!")
                            // Add for bookingDays for existing day new timeslot
                            existingDayForRemove = updatedDay
                            updatedDay.time += orderTime
                            print("Existing Day: \(updatedDay) Return new Time for Existing Day: \(orderTime)")
                            bookingDayToCheck = updatedDay
                            successBooking = true

                            return updatedDay
                        }
                        
                    }

                    return existingDay
                    successBooking = true

                }
                
            } else {
                print("No finding existing Days: \(bookingDayToCheck)")
                successBooking = true
            }
        } else {
            successBooking = true
        }

         if successBooking {
             print("Success Booking")
             print("Updete Date \(bookingDayToCheck)")

//             try await UserManager.shared.removeBookingDays(userId: authorId, removeBookingDays: bookingDayToCheck.date)
             try await UserManager.shared.setBookingDays(userId: authorId, bookingDay: bookingDayToCheck)
//             try await UserManager.shared.addNewOrder(userId: userDataResult.uid, order: DbOrderModel(order: orderData))

         } else {
             print("Error Booking")
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
