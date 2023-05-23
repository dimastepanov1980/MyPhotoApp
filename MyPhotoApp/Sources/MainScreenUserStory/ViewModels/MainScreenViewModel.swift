//
//  MainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

final class MainScreenViewModel: MainScreenViewModelType {
    @Published var userId: String = ""
    @Published var name: String  = ""
    @Published var place: String?
    @Published var dateOrder: Date  = Date()
    @Published var duration: Double = 0.0
    @Published var imageUrl: String = ""
    @Published var weaterId: String  = ""
    @Published var orders: [MainOrderModel] = [
        MainOrderModel(userId: "",
                       name: "Ira",
                       place: "Kata Noy Beach",
                       date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                       duration: 1.5,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Olga",
                       place: "Surin Beach",
                       date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date(),
                       duration: 2.0,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Vika",
                       place: "Kata Beach",
                       date: Date(),
                       duration: 1.5,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Dasha",
                       place: "Nai Ton Long Beach",
                       date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date(),
                       duration: 1.0,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Nastiy",
                       place: "Kamala Beach",
                       date: Calendar.current.date(byAdding: .day, value: +5, to: Date()) ?? Date(),
                       duration: 1.5,
                       imageUrl: "")
    ]
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var today: Date = Date()


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
}
