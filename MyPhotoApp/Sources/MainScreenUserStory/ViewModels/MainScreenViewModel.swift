//
//  MainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class MainScreenViewModel: MainScreenViewModelType {
    @Published var orders: [UserOrdersModel] = []
    @Published var weatherByDate: [Date: [Weather?]] = [:]
    @Published var weatherForCurrentDay: String? = nil
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    
/*    var filteredOtherOrders: [Date : [UserOrdersModel]] {
        var filteredOrders = [Date : [UserOrdersModel]]()
        let currentDate = Calendar.current.startOfDay(for: Date())
        let sortedFilteredOrders = filteredOrders.sorted { $0.key < $1.key }
        let sortedFilteredOrdersDictionary = Dictionary(uniqueKeysWithValues: sortedFilteredOrders)
        
        for order in orders {
            let date = Calendar.current.startOfDay(for: order.date)
            
            if date < currentDate {
                let orderDate = Calendar.current.startOfDay(for: date)
                if filteredOrders[orderDate] == nil {
                    filteredOrders[orderDate] = [order]
                } else {
                    filteredOrders[orderDate]?.append(order)
                }
            }
        }
        return sortedFilteredOrdersDictionary
    } */
    var filteredOtherOrders: [Date : [UserOrdersModel]] {
        var filteredOrders = [Date : [UserOrdersModel]]()
        
        let currentDate = Calendar.current.startOfDay(for: Date()) // Get the current date without time
        
        for order in orders {
            let date = Calendar.current.startOfDay(for: order.date) // Get the order date without time
            
            if date < currentDate {
                let orderDate = Calendar.current.startOfDay(for: date)
                if filteredOrders[orderDate] == nil {
                    filteredOrders[orderDate] = [order]
                } else {
                    filteredOrders[orderDate]?.append(order)
                }
            }
        }
        return filteredOrders
    }
    var filteredUpcomingOrders: [Date : [UserOrdersModel]] {
        var filteredOrders = [Date : [UserOrdersModel]]()
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        for order in orders {
            let date = Calendar.current.startOfDay(for: order.date)
            
            if date > currentDate {
                let orderDate = Calendar.current.startOfDay(for: date)
                if filteredOrders[orderDate] == nil {
                    filteredOrders[orderDate] = [order]
                } else {
                    filteredOrders[orderDate]?.append(order)
                }
            }
        }
        return filteredOrders
    }
    var filteredOrdersForToday: [UserOrdersModel] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        return orders.filter { order in
            let formattedOrderDate = dateFormatter.string(from: order.date)
            let formattedToday = dateFormatter.string(from: today)
            return formattedOrderDate == formattedToday
        }
    }
    
    init() {
    }
    func fetchWeather(lat: String, lon: String, exclude: String) async throws {
        let today = Date()
        let calendar = Calendar.current
        var weatherByDate: [Date: [Weather?]] = [:]
        let weather = try await WeatherManager.shared.fetcWeather(lat: lat, lon: lon, exclude: exclude)
        let weatherForAllDay = weather.daily
        let weatherForCurrentDay = weather.current.weather.first?.icon
        
        (0...14).forEach { day in
            let dayOfWeek = calendar.date(byAdding: .day, value: day, to: today)!
            let matchingDate = weatherForAllDay.first { formattedDate(date: dayOfWeek, format: "dd MMMM YYYY") == formattedDate(date: $0.dt, format: "dd MMMM YYYY") }
            
            if let matchingDate = matchingDate {
                weatherByDate[dayOfWeek] = matchingDate.weather
            } else {
                weatherByDate[dayOfWeek] = [nil]
            }
        }
        self.weatherForCurrentDay = weatherForCurrentDay
        self.weatherByDate = weatherByDate
    }
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDay, inSameDayAs: date)
    }
    func isTodayDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(today, inSameDayAs: date)
    }
    func loadOrders() async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.orders = try await UserManager.shared.getAllOrders(userId: authDateResult.uid)
    }
    func deleteOrder(order: UserOrdersModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try await UserManager.shared.removeOrder(userId: authDateResult.uid, order: order)
    }
}

enum StatusOrder {
    case Upcoming
    case InProgress
    case Done
    case Cancelled
}
