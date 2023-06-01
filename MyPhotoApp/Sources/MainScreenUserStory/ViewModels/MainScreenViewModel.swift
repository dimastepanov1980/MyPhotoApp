//
//  MainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

@MainActor
final class MainScreenViewModel: MainScreenViewModelType {
    @Published var weaterId: String  = ""
    @Published var orders: [MainOrderModel] = [
        MainOrderModel(id: UUID(),
                       name: "Ira",
                       instagramLink: nil,
                       place: "Kata Noy Beach",
                       price: 5500,
                       date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                       duration: 1.5,
                       description: nil,
                       imageUrl: ""),
        MainOrderModel(id: UUID(),
                       name: "Ira",
                       instagramLink: nil,
                       place: "Kata Noy Beach",
                       price: 5500,
                       date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date(),
                       duration: 1.5,
                       description: nil,
                       imageUrl: ""),
        MainOrderModel(id: UUID(),
                       name: "Ira",
                       instagramLink: nil,
                       place: "Kata Noy Beach",
                       price: 5500,
                       date: Calendar.current.date(byAdding: .day, value: +3, to: Date()) ?? Date(),
                       duration: 1.5,
                       description: nil,
                       imageUrl: ""),
    ]
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var today: Date = Date()
    @Published private(set) var getOrders: [UserOrders]? = nil

    
    init() {
        fetchCurrentWeek()
    }
    
    func createOrder() {
        //
    }
    
// MARK: Set the desired output date format
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: date)
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...14).forEach { day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekDay)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func isTodayDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(today, inSameDayAs: date)
    }
    
    func loadOrders() async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.getOrders = try await UserManager.shared.getAllOrders(userId: authDateResult.uid)
        //print("Orders: \(orders?.id)")

    }
}
