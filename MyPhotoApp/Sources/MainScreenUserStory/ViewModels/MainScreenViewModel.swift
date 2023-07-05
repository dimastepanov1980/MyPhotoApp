//
//  MainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation
import Combine

@MainActor
final class MainScreenViewModel: MainScreenViewModelType {
    @Published var orders: [UserOrdersModel] = []
    @Published var weatherByDate: [Date: [Weather?]] = [:]
    @Published var weatherForCurrentDay: String? = nil
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    init() {
    }
    
// MARK: Set the desired output date format
  
    
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
